$:.unshift(File.expand_path('./lib', ENV['rvm_path'])) # Add RVM's lib directory to the load path.
require "rvm/capistrano"                  # Load RVM's capistrano plugin.
require "bundler/capistrano"

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

set :rvm_ruby_string, '1.9.2'        # Or whatever env you want it to run in.
set :application, "assethandler"
set :repository,  "git@github.com:zlu/Asset-Handler.git"
set :scm, :git
set :user, "deployer"
set :rvm_type, :user
set :deploy_to, "/home/deployer/apps/#{application}"
set :branch, "master"

role :web, "173.255.241.49"

after 'deploy:update_code', 'deploy:symlink_shared'

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

set :start_thin, "bundle exec thin start -d -p 4857"
set :stop_thin, "bundle exec thin stop"

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do
     run "cd #{release_path} && #{start_thin}"
   end

   task :stop do
     run "cd #{release_path} && #{stop_thin}"
   end

   task :restart do
     run "cd #{release_path} && #{stop_thin}"
     run "cd #{release_path} && #{start_thin}"
   end

   desc "Symlink shared configs and folders on each release."
   task :symlink_shared do
     run "ln -nfs #{shared_path}/assets #{release_path}/assets"
   end
end