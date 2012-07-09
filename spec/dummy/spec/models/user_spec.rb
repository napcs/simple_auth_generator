require 'spec_helper'
describe User do
  
  def valid_attributes 
    { :username => "homer",
      :password => "test123!",
      :password_confirmation => "test123!",
      :email => "homer@springfieldnuclear.com"
    }   
  end

  describe "creating a new user" do
    it "creates the user with valid attributes" do
      homer = User.create!(valid_attributes)
    end
    
    it "requires a username" do
      user = User.new
      user.valid?
      user.errors[:username].should include("can't be blank")
    end
  
    it "requires an email" do
      user = User.new
      user.valid?
      user.errors[:email].should include("can't be blank")
    end
    
    it "requires a valid username" do
      user = User.new
      user.username = "homer simpson"
      user.valid?
      user.errors[:username].should include("should only contain letters, numbers, or .-_@")
    end
  
    it "requires a password" do
      user = User.new
      user.valid?
      user.errors[:password].should include("can't be blank")
    end
  
    it "requires a password and a matching confirmation" do
      user = User.new
      user.password = "abc123!"
      user.password_confirmation = "abc1234!"
      user.valid?
      user.errors[:password].should include("doesn't match confirmation")
    end

    it "has no activation token with normal save" do
      user = User.new(valid_attributes)
      user.save!
      user.activation_code.should be_nil
    end
    
    it "has an activation token when saved_with_activation" do
      user = User.new(valid_attributes)
      user.save_with_activation
      user.activation_code.should_not be_nil
    end
    
    it "has an encrypted password" do
      user = User.new(valid_attributes)
      user.save!
      user.password_digest.should_not be_nil
    end
    
  end
  
  describe "with an inactive %=model_name %>" do
    it "is activated when we call activate!" do
      user = User.new(valid_attributes)
      user.save!
      user.activate!
      user.activation_code.should be_nil
      user.activated_at.should_not be_nil
      user.should be_active
    end
  end
  
  describe "with an existing user" do

    let!(:existing_user) {User.create!(valid_attributes)}
    
    it "authenticates the user 'homer' with the correct password of 'test123!'" do
      User.authenticate("homer", "test123!").should == existing_user 
    end
    
    it "does not authenticate the user 'homer' with the incorrect password of 'test456!'" do
      User.authenticate("homer", "test456!").should be_false
    end
    
    it "allows the username to change without changing the password" do
      existing_user.update_attributes(:username => "foo").should == true
    end
    
    it "generates the password reset token" do
      existing_user.initiate_password_reset_request!
      existing_user.password_reset_token.should_not be_nil
    end
    
    it "grabs a user by the reset token" do
      existing_user.make_password_reset_token
      existing_user.save
      User.find_by_password_reset_token(existing_user.password_reset_token).should == existing_user
    end
    
    it "resets the password by the reset_password! method" do
      existing_user.make_password_reset_token
      existing_user.save
      params = {:user => {:password => "foo1234!!", :password_confirmation => "foo1234!!"}}
      existing_user.reset_password(params).should == true
      User.authenticate("homer", "foo1234!!").should_not be_nil
    end
  end
  
end
