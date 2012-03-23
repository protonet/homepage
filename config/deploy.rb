$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require "bundler/capistrano"

set :normalize_asset_timestamps, false
set :rvm_ruby_string, 'ruby-1.9.3-p0@protonet-homepage'
set :rvm_type, :system

set :scm, :git
set :branch, 'master'
set :user, 'deploy'

set :application, "homepage"
set :deploy_to, "/home/deploy/protonet/homepage"

set :use_sudo, false

set :deploy_via, :remote_cache
set :repository,  'git@github.com:henningthies/homepage.git'
set :ssh_options, {:forward_agent => true}
set :port, 22100

role :app, "dev.henning-thies.de", :primary => true
role :web, "dev.henning-thies.de", :primary => true

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
