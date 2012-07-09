class UserObserver < ActiveRecord::Observer

  def after_create(user)
    UserMailer.signup_notification(user).deliver if user.needs_signup_email?
  end

  def after_save(user)
   UserMailer.activation(user).deliver if user.recently_activated?
   UserMailer.password_change_request(user).deliver if user.needs_password_reset_mail?
  end

end