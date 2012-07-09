class UserMailer < ActionMailer::Base
  # consider putting this in an initializer instead, like this:
  #
  # config/initializers/email.rb
  #
  # ActionMailer::Base.smtp_settings = {  
  #   :address              => "smtp.yourhost.com",  
  #   :port                 => 587,  
  #   :domain               => "example.com",  
  #   :user_name            => "example",  
  #   :password             => "secret",  
  #   :authentication       => "plain",  
  # }  
  # ActionMailer::Base.default_url_options[:host] = "localhost:3000"
    
  default_url_options[:host] = "example.com"

  # set this to your email!
  default :from => "yourmail@example.com"  

  def signup_notification(user )
    subject     = "[YOURSITE] - Please Activate Your Account!"
    @user = user
    mail(:to => user.email, :subject => subject)  
  end
  
  def activation(user)
    subject     = "[YOURSITE] - Succesfully Activated Your Account!"
    @user = user
    mail(:to => user.email, :subject => subject)  
  end
  
  def password_change_request(user)
    subject     = "[YOURSITE] - Password reset instructions for your account!"
    @user = user
    mail(:to => user.email, :subject => subject)  
  end

end
