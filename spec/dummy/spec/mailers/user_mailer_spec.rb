require 'spec_helper'
describe UserMailer do
  
  def user_needing_activation
    if @user_needing_activation.nil?
      @user_needing_activation = User.new(:username => "homer",
                        :email => "homer@example.com",
                        :password => "homer!!",
                        :password_confirmation => "homer!!")

      @user_needing_activation.save_with_activation 
    end
    @user_needing_activation
  end

  def user_needing_password_reset
    if @user_needing_password_reset.nil?
      @user_needing_password_reset = User.create(:username => "homer",
                       :email => "homer@example.com",
                       :password => "homer!!",
                       :password_confirmation => "homer!!")
      @user_needing_password_reset.activate!
      @user_needing_password_reset.initiate_password_reset_request!
    end
    @user_needing_password_reset
  end

  describe "signup notification" do
    let(:signup_mailer) { UserMailer.signup_notification(user_needing_activation) }

    it "has the correct subject" do
      signup_mailer.subject.should include("Please Activate Your Account!")
    end

    it "has the user's email as the recipient" do
      signup_mailer.to.should eq([user_needing_activation.email])
    end

    it "has our email as the sender" do
      signup_mailer.from.should eq(["yourmail@example.com"])
    end
  end

  describe "activation confirmation" do
    let(:activation_mailer) { UserMailer.activation(user_needing_activation) }

    it "has the correct subject" do
      activation_mailer.subject.should include("Succesfully Activated Your Account!")
    end

    it "has the user's email as the recipient" do
      activation_mailer.to.should eq([user_needing_activation.email])
    end

    it "has our email as the sender" do
      activation_mailer.from.should eq(["yourmail@example.com"])
    end
  end

  describe "Password change request" do
    let(:password_change_request) { UserMailer.password_change_request(user_needing_password_reset) }

    it "has the correct subject" do
      password_change_request.subject.should include("Password reset instructions for your account!")
    end

    it "has the user's email as the recipient" do
      password_change_request.to.should eq([user_needing_password_reset.email])
    end

    it "has our email as the sender" do
      password_change_request.from.should eq(["yourmail@example.com"])
    end
  end
 
end
