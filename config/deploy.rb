set :application, "assethandler"
set :repository,  "git@github.com:zlu/Asset-Handler.git"

set :scm, :git

role :web, "173.255.241.49"

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
   task :start do
     run "#{try_sudo} thin start -d"
   end
   task :stop do
     run "#{try_sudo} thin stop"
   end
   task :restart, :roles => :app, :except => { :no_release => true } do

   end
end