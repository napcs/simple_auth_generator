#!/usr/bin/env rake
begin
  require 'bundler/setup'
rescue LoadError
  puts 'You must `gem install bundler` and `bundle install` to run rake tasks'
end
begin
  require 'rdoc/task'
rescue LoadError
  require 'rdoc/rdoc'
  require 'rake/rdoctask'
  RDoc::Task = Rake::RDocTask
end

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'SimpleAuthGenerator'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Bundler::GemHelper.install_tasks
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new('spec')

task :default => :spec

desc "Reinstalls the gem into the dummy app and  runs the generator"
task :rerun => :reset_dummy do
  Dir.chdir("spec/dummy") do
    `rails g simple_auth user`
    `bundle exec rake db:migrate && bundle exec rake db:test:prepare`
  end
end

desc "removes the generator files from the dummy app, removes migrations, removes database"
task :reset_dummy do
  Dir.chdir("spec/dummy") do 
    `rails destroy simple_auth user`
    FileUtils.rm_rf "db/test.sqlite3"
    FileUtils.rm_rf "db/development.sqlite3"
  end
end
