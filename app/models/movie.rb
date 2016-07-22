class Movie < ActiveRecord::Base

  has_many :reviews
  mount_uploader :image, ImageUploader

  validates :title,
    presence: true

  validates :director,
    presence: true

  validates :runtime_in_minutes,
    numericality: { only_integer: true }

  validates :description,
    presence: true

  # validates :poster_image_url,
  #   presence: true

  validates :release_date,
    presence: true

  validate :picture

  validate :release_date_is_in_the_past

  # Logic to search through movies in the db
  scope :search_title, -> (title) { where('title LIKE ?', "%#{title}%") if title.present? }
  scope :search_director, -> (director) { where('director LIKE ?', "%#{director}%") if director.present? }
  scope :search_runtime, -> (runtime_in_minutes) { 

    if runtime_in_minutes
      
      case runtime_in_minutes

      when '1'
        where('runtime_in_minutes < ?', 90)
      when '2'
        where(runtime_in_minutes: 90..120)
      when '3'
        where('runtime_in_minutes > ?', 120)
      end
    end
  }

  def review_average
    reviews.sum(:rating_out_of_ten) / reviews.size unless reviews.empty?
  end

  protected

  def release_date_is_in_the_past
    if release_date.present? && release_date > Date.today
      errors.add(:release_date, "should be in the past")
    end
  end

  def picture
    if image.present? ^ poster_image_url.present?
      true
    end
    false
  end

end
