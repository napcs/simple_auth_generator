require 'spec_helper'
describe <%=class_name %>Mailer do
  
  def <%=model_name %>_needing_activation
    if @<%=model_name %>_needing_activation.nil?
      @<%=model_name %>_needing_activation = <%= class_name %>.new(:username => "homer",
                        :email => "homer@example.com",
                        :password => "homer!!",
                        :password_confirmation => "homer!!")

      @<%=model_name %>_needing_activation.save_with_activation 
    end
    @<%=model_name %>_needing_activation
  end

  def <%= model_name %>_needing_password_reset
    if @<%= model_name %>_needing_password_reset.nil?
      @<%=model_name %>_needing_password_reset = <%= class_name %>.create(:username => "homer",
                       :email => "homer@example.com",
                       :password => "homer!!",
                       :password_confirmation => "homer!!")
      @<%=model_name %>_needing_password_reset.activate!
      @<%=model_name %>_needing_password_reset.initiate_password_reset_request!
    end
    @<%=model_name %>_needing_password_reset
  end

  describe "signup notification" do
    let(:signup_mailer) { <%= class_name %>Mailer.signup_notification(<%= model_name %>_needing_activation) }

    it "has the correct subject" do
      signup_mailer.subject.should include("Please Activate Your Account!")
    end

    it "has the user's email as the recipient" do
      signup_mailer.to.should eq([<%= model_name %>_needing_activation.email])
    end

    it "has our email as the sender" do
      signup_mailer.from.should eq(["yourmail@example.com"])
    end
  end

  describe "activation confirmation" do
    let(:activation_mailer) { <%= class_name %>Mailer.activation(<%=model_name %>_needing_activation) }

    it "has the correct subject" do
      activation_mailer.subject.should include("Succesfully Activated Your Account!")
    end

    it "has the user's email as the recipient" do
      activation_mailer.to.should eq([<%= model_name %>_needing_activation.email])
    end

    it "has our email as the sender" do
      activation_mailer.from.should eq(["yourmail@example.com"])
    end
  end

  describe "Password change request" do
    let(:password_change_request) { <%= class_name %>Mailer.password_change_request(<%= model_name %>_needing_password_reset) }

    it "has the correct subject" do
      password_change_request.subject.should include("Password reset instructions for your account!")
    end

    it "has the user's email as the recipient" do
      password_change_request.to.should eq([<%= model_name %>_needing_password_reset.email])
    end

    it "has our email as the sender" do
      password_change_request.from.should eq(["yourmail@example.com"])
    end
  end
 
end
