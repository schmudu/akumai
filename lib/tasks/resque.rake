require 'bundler/setup'
Bundler.require(:default)

require 'resque/tasks'

task "resque:setup" do
      ENV['QUEUE'] = '*'
end

# load the Rails app all the time
namespace :resque do
  puts "Loading Rails environment for Resque"
  task :setup => :environment do
    ActiveRecord::Base.descendants.each { |klass|  klass.columns }
  end
end