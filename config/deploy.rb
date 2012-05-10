$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require "bundler/capistrano"

set :normalize_asset_timestamps, false
set :rvm_ruby_string, 'ruby-1.9.3-p194'
set :rvm_type, :system

set :scm, :git
set :branch, 'master'
set :user, 'protonet'

set :application, "homepage"
set :deploy_to, "/home/protonet/homepage"

set :use_sudo, false

set :deploy_via, :remote_cache
set :repository,  'git://github.com/protonet/homepage.git'
set :ssh_options, {:forward_agent => true}
set :port, 22

role :app, "78.47.145.222", :primary => true
role :web, "78.47.145.222", :primary => true

# tasks
namespace :deploy do
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

after "deploy:update_code", "customs:config"
namespace(:customs) do
  task :config, :roles => :app do
    run <<-CMD
      ln -nfs #{shared_path}/config/config.yml #{release_path}/config.yml
    CMD
  end
end
