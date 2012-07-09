require 'spec_helper'
require 'generators/simple_auth/setup_generator'
describe SimpleAuthGenerator::SetupGenerator do
  DESTINATION = File.expand_path("../../tmp", __FILE__)
	destination DESTINATION

	before do 
	  prepare_destination 
    # For some reason I need a routes.rb file because the generator tries to modify it 
    # and complains if it's not there.
	  FileUtils.mkdir(File.join( DESTINATION, "config"))
    FileUtils.touch(File.join( DESTINATION, "config", "routes.rb"))
  end

  describe "with default options" do
    before { run_generator %w(user) }            

    
    describe 'The simpleauth library' do
      subject { file('lib/simple_authentication.rb') }
      it { should exist }
    end
    
    describe 'The simpleauth initializer' do
      subject { file('config/initializers/simple_auth.rb') }
      it { should exist }
      it { should contain("require Rails.root.join(\"lib/simple_authentication\")")}
    end

    describe 'users controller' do
      subject { file('app/controllers/users_controller.rb') }
      it { should exist }
    end

    describe 'user model' do
      subject { file('app/models/user.rb') }
      it { should exist }
      it { should contain("has_secure_password" ) }
    end
    
    describe 'user mailer' do
      subject { file('app/mailers/user_mailer.rb') }
      it { should exist }
    end
    describe "the model spec" do
      subject { file('spec/models/user.rb') }
      it { should_not exist }
    end

    describe "the user controller spec" do
      subject { file('spec/controllers/users_controller.rb') }
      it { should_not exist }
    end

    describe "the password reset controller spec" do
      subject { file('spec/controllers/password_resets_controller.rb') }
      it { should_not exist }
    end

    describe "the sessions controller spec" do
      subject { file('spec/controllers/sessions_controller.rb') }
      it { should_not exist }
    end
  end

	describe 'users migration' do
	  describe "with default options" do
      subject { file(Dir.glob(File.join(DESTINATION, "db", "migrate", "*_create_users.rb")).first) }
      before { run_generator %w(user) }            
      it { should exist }
      it { should contain("password_digest") }
      it { should contain("add_index :users, :username, :unique => true") }
    end
    describe "with --skip-migration option" do
      before { run_generator %w(user --skip-migration) }            
      it "should not create a migration" do
        Dir.glob(File.join(DESTINATION, "db", "migrate", "*_create_users.rb")).first.should be_nil
      end
    end
    
    describe "with --skip-specs option" do
      before { run_generator %w(user --skip-specs) }            

      describe "the model spec" do
        subject { file('spec/models/user.rb') }
        it { should_not exist }
      end

      describe "the user controller spec" do
        subject { file('spec/controllers/users_controller.rb') }
        it { should_not exist }
      end

      describe "the password reset controller spec" do
        subject { file('spec/controllers/password_resets_controller.rb') }
        it { should_not exist }
      end

      describe "the sessions controller spec" do
        subject { file('spec/controllers/sessions_controller.rb') }
        it { should_not exist }
      end
    end
  end
end
