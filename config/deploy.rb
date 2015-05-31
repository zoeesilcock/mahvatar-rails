require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
require 'mina/rbenv'
require 'mina/puma'

set :domain, 'zoeetrope.com'
set :deploy_to, '/home/deployer/mahvatar'
set :repository, 'https://github.com/zoeesilcock/mahvatar.git'
set :branch, 'master'
set :user, 'deployer'
set :forward_agent, true
set :port, '22'

task :setup => :environment do
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/config")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/sockets")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/sockets")
  queue! %(mkdir -p "#{deploy_to}/#{shared_path}/tmp/pids")
  queue! %(chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/tmp/pids")
end

set :shared_paths, ['config/database.yml', 'tmp/pids', 'tmp/sockets', 'public/uploads']

task :environment do
  invoke :'rbenv:load'
end

task :deploy => :environment do
  deploy do
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'

    to :launch do
      invoke :'puma:restart'
    end
  end
end
