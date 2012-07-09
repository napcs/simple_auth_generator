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
  
  describe "Logging in with the correct password" do
    before(:each) do
      post :create, {:username => "homer", :password => "test123!"}
    end
    
    it "sets the user as current_<%=model_name%>" do
      assigns(:current_<%=model_name %>).should eq(existing_<%=model_name %>)
    end 
    
    it "should redirect to the root" do
      response.should redirect_to root_url
    end
    
  end
  
  describe "Logging in with an incorrect password" do
    before(:each) do
      post :create, {:username => "homer", :password => "test123"}
    end
    
    it "redisplays the login page" do
      response.should render_template(:new)
    end
    
  end
  
end