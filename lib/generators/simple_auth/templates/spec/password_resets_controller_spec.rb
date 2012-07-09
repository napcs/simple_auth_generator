require 'spec_helper'
describe PasswordResetsController do
 
  render_views
   
  def valid_attributes 
    { :username => "homer",
      :password => "test123!",
      :email => "homer@springfieldnuclear.com"
     }
  end   

  let(:existing_<%=model_name %>){ <%=class_name %>.create!(valid_attributes) }
  
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
      existing_<%=model_name %>.initiate_password_reset_request!
      get :edit, {:token => existing_<%=model_name %>.password_reset_token }
      assigns(:<%=model_name %>).should be_a <%=class_name %>
    end
    
  end

end
