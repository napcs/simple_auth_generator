module SimpleAuthentication
  protected
    # Returns true or false if the <%=model_name %> is logged in.
    # Preloads @current_<%=model_name %> with the <%=model_name %> model if they're logged in.
    def logged_in?
      !!current_<%=model_name %>
    end

    # Accesses the current <%=model_name %> from the session. 
    # Future calls avoid the database because nil is not equal to false.
    def current_<%=model_name %>
      @current_<%=model_name %> ||= (login_from_session || login_from_basic_auth || login_from_cookie) unless @current_<%=model_name %> == false
    end

    # Store the given <%=model_name %> id in the session.
    def current_<%=model_name %>=(new_<%=model_name %>)
      session[:<%=model_name %>_id] = new_<%=model_name %> ? new_<%=model_name %>.id : nil
      @current_<%=model_name %> = new_<%=model_name %> || false
    end

    # Check if the <%=model_name %> is authorized
    #
    # Override this method in your controllers if you want to restrict access
    # to only a few actions or if you want to check if the <%=model_name %>
    # has the correct rights.
    #
    # Example:
    #
    #  # only allow nonbobs
    #  def authorized?
    #    current_<%=model_name %>.login != "bob"
    #  end
    def authorized?
      logged_in?
    end

    # Filter method to enforce a login requirement.
    #
    # To require logins for all actions, use this in your controllers:
    #
    #   before_filter :login_required
    #
    # To require logins for specific actions, use this in your controllers:
    #
    #   before_filter :login_required, :only => [ :edit, :update ]
    #
    # To skip this in a subclassed controller:
    #
    #   skip_before_filter :login_required
    #
    def login_required
      authorized? || access_denied
    end

    # Redirect as appropriate when an access request fails.
    #
    # The default action is to redirect to the login screen.
    #
    # Override this method in your controllers if you want to have special
    # behavior in case the <%=model_name %> is not authorized
    # to access the requested action.  For example, a popup window might
    # simply close itself.
    def access_denied
      respond_to do |format|
        format.html do
          store_location
          redirect_to login_url
        end
        format.any do
          request_http_basic_authentication 'Web Password'
        end
      end
    end

    # Store the URI of the current request in the session.
    #
    # We can return to this location by calling #redirect_back_or_default.
    def store_location
      session[:return_to] = request.fullpath
    end

    # Redirect to the URI stored by the most recent store_location call or
    # to the passed default.
    def redirect_back_or_default(default, options = {})
      redirect_to(session[:return_to] || default, options)
      session[:return_to] = nil
    end

    # Inclusion hook to make #current_<%=model_name %> and #logged_in?
    # available as ActionView helper methods.
    def self.included(base)
      base.send :helper_method, :current_<%=model_name %>, :logged_in?
    end

    # Called from #current_<%=model_name %>.  First attempt to login by the <%=model_name %> id stored in the session.
    def login_from_session
      self.current_<%=model_name %> = <%=class_name %>.find_by_id(session[:<%=model_name %>_id]) if session[:<%=model_name %>_id]
    end

    # Called from #current_<%=model_name %>.  Now, attempt to login by basic authentication information.
    def login_from_basic_auth
      authenticate_with_http_basic do |username, password|
        self.current_<%=model_name %> = <%=class_name %>.authenticate(username, password)
      end
    end

    # Called from #current_<%=model_name %>.  Finaly, attempt to login by an expiring token in the cookie.
    def login_from_cookie
      <%=model_name %> = cookies[:auth_token] && <%=class_name %>.find_by_remember_token(cookies[:auth_token])
      if <%=model_name %> && <%=model_name %>.remember_token?
        cookies[:auth_token] = { :value => <%=model_name %>.remember_token, :expires => <%=model_name %>.remember_token_expires_at }
        self.current_<%=model_name %> = <%=model_name %>
      end
    end
end
