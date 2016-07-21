class UserMailer < ApplicationMailer

  def user_deleted(user)
    @user = user
    @url = '/admin/users'
    mail(to: @user.email, subject: 'Your account has been deleted by an admin.')
  end

end
