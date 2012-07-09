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
    it "activates the user with a valid user that needs activation" do
      @user = User.new valid_attributes
      @user.save_with_activation
      get :activate, {:token =>  @user.activation_code}
      response.should redirect_to(root_url)
      flash[:notice].should include("Account activated.")
    end
    
    it "logs the user in when activating" do
      @user = User.new valid_attributes
      @user.save_with_activation
      get :activate, {:token =>  @user.activation_code}
      session[:user_id].should == @user.id
    end
    
    it "should not try to activate the user when the user is already active" do
      @user = User.create! valid_attributes
      get :activate, {:token => "asdflkj1234"}
      flash[:notice].should include("Can't find that user ")
    end
  end

end
