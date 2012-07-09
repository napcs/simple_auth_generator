class <%= class_name %>Observer < ActiveRecord::Observer

  def after_create(<%= model_name %>)
    <%= class_name %>Mailer.signup_notification(<%= model_name %>).deliver if <%= model_name %>.needs_signup_email?
  end

  def after_save(<%= model_name %>)
   <%= class_name %>Mailer.activation(<%= model_name %>).deliver if <%= model_name %>.recently_activated?
   <%= class_name %>Mailer.password_change_request(<%= model_name %>).deliver if <%= model_name %>.needs_password_reset_mail?
  end

end