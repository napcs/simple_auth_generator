require 'spec_helper'
describe UsersController do
 
  render_views
   
  def valid_attributes
    { :username => "homer",
      :password => "test123!",
      :email => "homer@springfieldnuclear.com"
    }
  end

  describe "the new user page" do
    it "should render the new template" do
      get :new
      response.should render_template(:new)
    end
  end
  
  describe "the create action" do
    it "should render the activation_mail template" do
      post :create, {:user =>  valid_attributes}
      response.should render_template(:activation_mail)
    end
    
    it "sends the password reset instructions email" do
      ActionMailer::Base.deliveries = []
      post :create, {:user =>  valid_attributes}
      ActionMailer::Base.deliveries.length.should == 1
    end
  end

  describe "The activation url" do
    it "activates the <%=model_name %> with a valid user that needs activation" do
      @<%=model_name %> = <%=class_name %>.new valid_attributes
      @<%=model_name %>.save_with_activation
      get :activate, {:token =>  @<%=model_name %>.activation_code}
      response.should redirect_to(root_url)
      flash[:notice].should include("Account activated.")
    end
    
    it "logs the <%=model_name %> in when activating" do
      @<%=model_name %> = <%=class_name %>.new valid_attributes
      @<%=model_name %>.save_with_activation
      get :activate, {:token =>  @<%=model_name %>.activation_code}
      session[:<%=model_name %>_id].should == @<%=model_name %>.id
    end
    
    it "should not try to activate the <%=model_name %> when the user is already active" do
      @<%=model_name %> = <%=class_name %>.create! valid_attributes
      get :activate, {:token => "asdflkj1234"}
      flash[:notice].should include("Can't find that <%=model_name %> ")
    end
  end

end
