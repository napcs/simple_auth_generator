class SessionsController < ApplicationController  
  include ::SimpleAuthentication
  
  def new  
  end  
    
  def create  
    <%=model_name %> = <%=class_name %>.authenticate(params[:username], params[:password])  
    if <%=model_name %> 
      if <%=model_name %>.active? 
        reset_session
        self.current_<%=model_name %> = <%=model_name %>
        new_cookie_flag = (params[:remember_me] == "1")
        handle_remember_cookie! new_cookie_flag
        redirect_back_or_default(root_url, :notice => "Logged in successfully")
      else
        @username       = params[:username]
        @remember_me = params[:remember_me]
        flash.now.alert = "Your account is not active yet."  
        render "new"
      end
    else  
      @username       = params[:username]
      @remember_me = params[:remember_me]
      flash.now.alert = "Invalid login or password"  
      render "new"  
    end  
  end  
  
  def destroy
    logout_killing_session!
    flash.notice = "You've been logged out."
    redirect_to root_url
  end
end