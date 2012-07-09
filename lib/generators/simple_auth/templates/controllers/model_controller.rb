class <%=class_name.pluralize %>Controller < ApplicationController
  include ::SimpleAuthentication
  
  def new
    @<%=model_name %> =  <%=class_name %>.new
  end
  
  # GET /activate/:activation_code
  def activate
    @<%=model_name %> =  <%=class_name %>.find_by_activation_code(params[:token])
    if @<%=model_name %>.nil?
      redirect_to root_url, :notice => "Can't find that <%=model_name %> ." 
    else
      @<%=model_name %>.activate!
      self.current_<%=model_name %> = @<%=model_name %>
      <%= class_name %>Mailer.activation(@<%= model_name %>).deliver if @<%= model_name %>.recently_activated?
      redirect_back_or_default('/', :notice => "Account activated. You've been logged in successfully")
    end
  
  end
  
  def create
    @<%=model_name %> = <%=class_name %>.new(params[:<%=model_name %>])
    if @<%=model_name %>.save_with_activation
      <%= class_name %>Mailer.signup_notification(@<%= model_name %>).deliver if @<%= model_name %>.needs_signup_email?
      render :action => "activation_mail"
    else
      render :action => "new"
    end
  end
  
  
end
