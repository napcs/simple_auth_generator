class User < ActiveRecord::Base
  attr_accessible :username, :password, :password_confirmation, :email
  
  has_secure_password

  LOGIN_REGEX       = /\A[[:alnum:]][[:alnum:]\.\-_@]+\z/     # Unicode, strict
  
  validates_confirmation_of :password  

  validates_presence_of     :password, 
                            :on => :create  

  validates_presence_of     :username, :email
  
  validates_uniqueness_of   :username, :email, :allow_blank => true

  validates_format_of       :username, 
                            :with => LOGIN_REGEX,
                            :allow_blank => true, 
                            :message => "should only contain letters, numbers, or .-_@"

  # Activates the account by setting the activated_at field
  # and then sets the 'activated' instance variable which
  # the recently_activated? method uses.  
  def activate!
    @activated = true
    self.activated_at = Time.now.utc
    self.activation_code = nil
    save(:validate => false)
  end
  
  # Returns true if the user has just been activated.
  # Relies on an instance variable that is only set
  # in the activate! method. Nice for determining
  # if you need to send an email or do some other task.
  def recently_activated?
    @activated
  end
  
  # returns true if we have to send a signup email. Uses
  # the needs_signup_email instance var which is set
  # in the save_with_activation method.
  def needs_signup_email?
    @needs_signup_email
  end
  
  # returns true if we have to send a password reset email
  def needs_password_reset_mail?
    @needs_password_reset_mail
  end
  
  # creates an activation code, sets flag for the email,
  # and saves.
  def save_with_activation
    self.make_activation_code
    @needs_signup_email = true
    self.save
  end

  # returns true if the user is active
  def active?
    # the existence of an activation code means they have not activated yet
    self.activation_code.nil? && self.activated_at.present?
  end
  
  # creates the activation code
  def make_activation_code
    self.activation_code = User.friendly_token
  end
  
  # creates the password reset token for the url
  # and sets the flag to send the email.
  # saves the record.
  def initiate_password_reset_request!
    make_password_reset_token
    @needs_password_reset_mail = true
    self.save
  end
  
  # creates the password reset token
  def make_password_reset_token
    self.password_reset_token = User.friendly_token
  end

  # resets the password from the parameters provided.
  # and saves the record. Returns true if saved
  # and false if not.
  def reset_password(params={})
    self.password_reset_token = nil
    self.password = params[:user][:password]
    self.password_confirmation = params[:user][:password_confirmation]
    self.save
  end
  
  # Class method convenience wrapper for authentication,
  # to clean up controllers.
  # Returns the user object if found
  def self.authenticate(username, pass)
    user = User.find_by_username(username)
    if user
      user.authenticate(pass)
    end
  end
  
  private
    def self.friendly_token
      SecureRandom.base64(15).tr('+/=', '-_ ').strip.delete("\n")
    end
  
end
