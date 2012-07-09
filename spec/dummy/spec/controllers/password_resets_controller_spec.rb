require 'spec_helper'
describe PasswordResetsController do
 
  render_views
   
  def valid_attributes 
    { :username => "homer",
      :password => "test123!",
      :email => "homer@springfieldnuclear.com"
     }
  end   

  let(:existing_user){ User.create!(valid_attributes) }
  
  describe "the new page" do
    it "renders the new template" do
      get :new
      response.should render_template(:new)
    end
  end
  
  describe "the create action" do
    it "renders the mail_sent template" do
      post :create, {:email => existing_user.email }
      response.should render_template(:mail_sent)
    end
    
    it "sends the password reset instructions email" do
      ActionMailer::Base.deliveries = []
      post :create, {:email => existing_user.email}
      ActionMailer::Base.deliveries.length.should == 1
    end
    
  end
  
  describe "The edit action" do
    it "finds the record by token" do
      existing_user.initiate_password_reset_request!
      get :edit, {:token => existing_user.password_reset_token }
      assigns(:user).should be_a User
    end
    
  end

end
