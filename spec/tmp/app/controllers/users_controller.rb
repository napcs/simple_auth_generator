class UsersController < ApplicationController
  include ::SimpleAuthentication
  
  def new
    @user =  User.new
  end
  
  # GET /activate/:activation_code
  def activate
    @user =  User.find_by_activation_code(params[:token])
    if @user.nil?
      redirect_to root_url, :notice => "Can't find that user ." 
    else
      @user.activate!
      self.current_user = @user
      UserMailer.activation(@user).deliver if @user.recently_activated?
      redirect_back_or_default('/', :notice => "Account activated. You've been logged in successfully")
    end
  
  end
  
  def create
    @user = User.new(params[:user])
    if @user.save_with_activation
      UserMailer.signup_notification(@user).deliver if @user.needs_signup_email?
      render :action => "activation_mail"
    else
      render :action => "new"
    end
  end
  
  
end
