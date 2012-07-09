class PasswordResetsController < ApplicationController
  
  # This displays the form to request a password
  # reset
  def new
  end
  
  # This handles the password reset
  # and sends the email.
  def create
    @<%=model_name %> = <%=class_name %>.find_by_email(params[:email])
    
    if @<%=model_name %>.initiate_password_reset_request!
      <%= class_name %>Mailer.password_change_request(@<%= model_name %>).deliver if @<%= model_name %>.needs_password_reset_mail?
      render :action => "mail_sent"
    else
      flash.now[:notice] = "That email doesn't exist in our system."
      render :action => "new"
    end
    
  end
  
  # Looks up the user by the reset token
  # and presents the password reset form.
  def edit
    @<%=model_name %> = <%=class_name %>.find_by_password_reset_token(params[:token])  
  end
  
  # Updates the password in the database.
  def update
    @<%=model_name %> = <%=class_name %>.find_by_password_reset_token(params[:token])
    if <%=model_name %>.reset_password(params)
      redirect_to root_url, :notice => "Your password was successfully reset. Try logging in now."
    else
      render :action => "edit"
    end
  end
  
end
