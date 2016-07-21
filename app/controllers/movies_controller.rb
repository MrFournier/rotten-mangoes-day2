class MoviesController < ApplicationController

  def index
    @movies = Movie.all

    if params[:title]
      @movies = @movies.where('title LIKE ?', "%#{params[:title]}%")
    end
    if params[:director]
      @movies = @movies.where('director LIKE ?', "%#{params[:director]}%")
    end
    if params[:runtime_in_minutes]
      
      case params[:runtime_in_minutes]

      when '1'
        @movies = @movies.where('runtime_in_minutes < ?', 90)
      when '2'
        @movies = @movies.where(runtime_in_minutes: 90..120)
      when '3'
        @movies = @movies.where('runtime_in_minutes > ?', 120)
      end
    end
  end

  def show
    @movie = Movie.find(params[:id])
  end

  def new
    @movie = Movie.new
  end

  def edit
    @movie = Movie.find(params[:id])
  end

  def create
    @movie = Movie.new(movie_params)

    if @movie.save
      redirect_to movies_path, notice: "#{@movie.title} was submitted successfully!"
    else
      render :new
    end
  end

  def update
    @movie = Movie.find(params[:id])

    if @movie.update_attributes(movie_params)
      redirect_to movie_path(@movie)
    else
      render :edit
    end
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    redirect_to movies_path
  end

  protected

  def movie_params
    params.require(:movie).permit(
      :title, :release_date, :director, :runtime_in_minutes, :poster_image_url, :image, :rating_out_of_ten, :description
    )
  end

end