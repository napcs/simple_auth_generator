require 'spec_helper'
describe <%=class_name %> do
  
  def valid_attributes 
    { :username => "homer",
      :password => "test123!",
      :password_confirmation => "test123!",
      :email => "homer@springfieldnuclear.com"
    }   
  end

  describe "creating a new <%=model_name %>" do
    it "creates the <%=model_name %> with valid attributes" do
      homer = <%=class_name %>.create!(valid_attributes)
    end
    
    it "requires a username" do
      <%=model_name %> = <%=class_name %>.new
      <%=model_name %>.valid?
      <%=model_name %>.errors[:username].should include("can't be blank")
    end
  
    it "requires an email" do
      <%=model_name %> = <%=class_name %>.new
      <%=model_name %>.valid?
      <%=model_name %>.errors[:email].should include("can't be blank")
    end
    
    it "requires a valid username" do
      <%=model_name %> = <%=class_name %>.new
      <%=model_name %>.username = "homer simpson"
      <%=model_name %>.valid?
      <%=model_name %>.errors[:username].should include("should only contain letters, numbers, or .-_@")
    end
  
    it "requires a password" do
      <%=model_name %> = <%=class_name %>.new
      <%=model_name %>.valid?
      <%=model_name %>.errors[:password].should include("can't be blank")
    end
  
    it "requires a password and a matching confirmation" do
      <%=model_name %> = <%=class_name %>.new
      <%=model_name %>.password = "abc123!"
      <%=model_name %>.password_confirmation = "abc1234!"
      <%=model_name %>.valid?
      <%=model_name %>.errors[:password].should include("doesn't match confirmation")
    end

    it "has no activation token with normal save" do
      <%=model_name %> = <%=class_name %>.new(valid_attributes)
      <%=model_name %>.save!
      <%=model_name %>.activation_code.should be_nil
    end
    
    it "has an activation token when saved_with_activation" do
      <%=model_name %> = <%=class_name %>.new(valid_attributes)
      <%=model_name %>.save_with_activation
      <%=model_name %>.activation_code.should_not be_nil
    end
    
    it "has an encrypted password" do
      <%=model_name %> = <%=class_name %>.new(valid_attributes)
      <%=model_name %>.save!
      <%=model_name %>.password_digest.should_not be_nil
    end
    
  end
  
  describe "with an inactive %=model_name %>" do
    it "is activated when we call activate!" do
      <%=model_name %> = <%=class_name %>.new(valid_attributes)
      <%=model_name %>.save!
      <%=model_name %>.activate!
      <%=model_name %>.activation_code.should be_nil
      <%=model_name %>.activated_at.should_not be_nil
      <%=model_name %>.should be_active
    end
  end
  
  describe "with an existing user" do

    let!(:existing_<%=model_name %>) {<%=class_name %>.create!(valid_attributes)}
    
    it "authenticates the user 'homer' with the correct password of 'test123!'" do
      <%=class_name %>.authenticate("homer", "test123!").should == existing_<%=model_name %> 
    end
    
    it "does not authenticate the user 'homer' with the incorrect password of 'test456!'" do
      <%=class_name %>.authenticate("homer", "test456!").should be_false
    end
    
    it "allows the username to change without changing the password" do
      existing_<%=model_name %>.update_attributes(:username => "foo").should == true
    end
    
    it "generates the password reset token" do
      existing_<%=model_name %>.initiate_password_reset_request!
      existing_<%=model_name %>.password_reset_token.should_not be_nil
    end
    
    it "grabs a user by the reset token" do
      existing_<%=model_name %>.make_password_reset_token
      existing_<%=model_name %>.save
      <%=class_name %>.find_by_password_reset_token(existing_<%=model_name %>.password_reset_token).should == existing_<%=model_name %>
    end
    
    it "resets the password by the reset_password! method" do
      existing_<%=model_name %>.make_password_reset_token
      existing_<%=model_name %>.save
      params = {:user => {:password => "foo1234!!", :password_confirmation => "foo1234!!"}}
      existing_<%=model_name %>.reset_password(params).should == true
      <%=class_name %>.authenticate("homer", "foo1234!!").should_not be_nil
    end
  end
  
end
