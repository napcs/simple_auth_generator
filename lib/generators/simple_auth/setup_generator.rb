require 'rails/generators'
require 'rails/generators/migration'     
require 'rails/generators/named_base'
module SimpleAuth
  class SetupGenerator < Rails::Generators::NamedBase
    VERSION = "0.0.1"
  
    include Rails::Generators::Migration
  
    source_root File.expand_path('../templates', __FILE__)
    argument :model_name, :type => :string, :default => "user"  
    class_option :migration, :type => :boolean, :default => true, :description => "Include migration"  
    class_option :specs, :type => :boolean, :default => true, :description => "Include specs"  
  
  
    def generate_simple_auth
      template "lib/simple_authentication.rb", "lib/simple_authentication.rb" 
      if options.migration?
        migration_template 'migrate/create_model.rb', "db/migrate/create_#{table_name}.rb"
      end
      template "models/model.rb", "app/models/#{model_name}.rb"  

      template "controllers/sessions_controller.rb", "app/controllers/sessions_controller.rb"  
      template "views/sessions/new.html.erb", "app/views/sessions/new.html.erb"  
      template "controllers/model_controller.rb", "app/controllers/#{model_name.pluralize}_controller.rb"  
      template "views/model/new.html.erb", "app/views/#{model_name.pluralize}/new.html.erb"  
      template "views/model/activation_mail.html.erb", "app/views/#{model_name.pluralize}/activation_mail.html.erb"  
      template "controllers/password_resets_controller.rb", "app/controllers/password_resets_controller.rb"   
      template "views/password_resets/new.html.erb", "app/views/password_resets/new.html.erb"  
      template "views/password_resets/mail_sent.html.erb", "app/views/password_resets/mail_sent.html.erb"  
      template "views/password_resets/edit.html.erb", "app/views/password_resets/edit.html.erb"  
      template "views/mailer/password_change_request.html.erb", "app/views/#{model_name}_mailer/password_change_request.html.erb"  
      template "views/mailer/activation.html.erb", "app/views/#{model_name}_mailer/activation.html.erb" 
      template "views/mailer/signup_notification.html.erb", "app/views/#{model_name}_mailer/signup_notification.html.erb"  
    end

    def generate_specs

      if options.specs?
        template "spec/model_spec.rb", "spec/models/#{model_name}_spec.rb"
        template "spec/mailer_spec.rb", "spec/mailers/#{model_name}_mailer_spec.rb"
        template "spec/model_controller_spec.rb", "spec/controllers/#{model_name.pluralize}_controller_spec.rb"
        template "spec/sessions_controller_spec.rb", "spec/controllers/sessions_controller_spec.rb"
        template "spec/password_resets_controller_spec.rb", "spec/controllers/password_resets_controller_spec.rb"
      end
    end

    def generate_routes
      route "resources :#{model_name.pluralize}" 
      route 'resources :sessions, :only => [:new, :create, :destroy]'
      route 'get "/logout" => "sessions#destroy"'
      route 'get "/login" => "sessions#new"'
      route "get \"/activate/:token\" => \"#{model_name.pluralize}#activate\", :as => \"activate\""
      route 'get "/request_password_reset" => "password_resets#new", :as => "request_password_reset"'
      route 'post "/request_password_reset" => "password_resets#create", :as => "request_password_reset"'
      route 'get "/password_reset/:token" => "password_resets#edit", :as => "password_reset"'
      route 'put "/password_reset/:token" => "password_resets#update", :as => "password_reset"'
    end

    def generate_initializer
      initializer("simple_auth.rb") do
        %Q{# created by simpleauth generator #{Date.today}
  require Rails.root.join("lib/simple_authentication")}
      end
    end

    def generate_mailer
      template "mailers/mailer.rb", "app/mailers/#{model_name}_mailer.rb"  
    end
  
    # Implement the required interface for Rails::Generators::Migration.
    # taken from http://github.com/rails/rails/blob/master/activerecord/lib/generators/active_record.rb
    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        Time.now.utc.strftime("%Y%m%d%H%M%S")
      else
        "%.3d" % (current_migration_number(dirname) + 1)
      end
    end

    private 

    def appname
      Rails.root.split.last.to_s.classify
    end
  
    def class_name
      model_name.classify
    end
  
    def table_name
      model_name.pluralize
    end
  end
end