$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "simple_auth_generator"
  s.version     = SimpleAuthGenerator::VERSION
  s.authors     = ["Brian Hogan"]
  s.email       = ["brianhogan@napcs.com"]
  s.homepage    = "http://www.github.com/napcs/simple_auth_generator"
  s.summary     = "Authentication generator for Rails 3.1 and above"
  s.description = "Generates signup, password recovery, and authentication for Rails 3.1 applications. Instead of using libraries, this code just exists in your project where you can maintain it yourself."

  s.files = [
    "lib/version.rb",
    "lib/simple_auth.rb",
    "lib/generators/simple_auth/setup_generator.rb",
    "lib/generators/simple_auth/USAGE",
    "lib/generators/simple_auth/templates/controllers/model_controller.rb",
    "lib/generators/simple_auth/templates/controllers/password_resets_controller.rb",
    "lib/generators/simple_auth/templates/controllers/sessions_controller.rb",
    "lib/generators/simple_auth/templates/lib/simple_authentication.rb",
    "lib/generators/simple_auth/templates/mailers/mailer.rb",
    "lib/generators/simple_auth/templates/migrate/create_model.rb",
    "lib/generators/simple_auth/templates/controllers/password_resets_controller.rb",
    "lib/generators/simple_auth/templates/models/model.rb",
    "lib/generators/simple_auth/templates/spec/mailer_spec.rb",
    "lib/generators/simple_auth/templates/spec/model_controller_spec.rb",
    "lib/generators/simple_auth/templates/spec/model_spec.rb",
    "lib/generators/simple_auth/templates/spec/password_resets_controller_spec.rb",
    "lib/generators/simple_auth/templates/spec/sessions_controller_spec.rb",
    "lib/generators/simple_auth/templates/views/mailer/activation.html.erb",
    "lib/generators/simple_auth/templates/views/mailer/password_change_request.html.erb",
    "lib/generators/simple_auth/templates/views/mailer/signup_notification.html.erb",
    "lib/generators/simple_auth/templates/views/model/activation_mail.html.erb",
    "lib/generators/simple_auth/templates/views/model/new.html.erb",
    "lib/generators/simple_auth/templates/views/password_resets/new.html.erb",
    "lib/generators/simple_auth/templates/views/password_resets/edit.html.erb",
    "lib/generators/simple_auth/templates/views/password_resets/mail_sent.html.erb",
    "lib/generators/simple_auth/templates/views/sessions/new.html.erb",
    "MIT-LICENSE", "Rakefile", "README.rdoc"]
  #s.test_files = Dir["spec/**/*"]
  
  s.add_dependency "rails", ">= 3.1.0"
  s.add_dependency "rspec-rails"
  s.add_dependency "bcrypt-ruby"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "ammeter"
  s.add_development_dependency "autotest"
  s.add_development_dependency "autotest-fsevent"

end
