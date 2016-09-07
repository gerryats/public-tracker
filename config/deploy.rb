require 'mina/bundler'
require 'mina/rails'
require 'mina/git'
# require 'mina/rbenv'  # for rbenv support. (http://rbenv.org)
# require 'mina/rvm'    # for rvm support. (http://rvm.io)

# Basic settings:
#   domain       - The hostname to SSH to.
#   deploy_to    - Path to deploy into.
#   repository   - Git repo to clone from. (needed by mina/git)
#   branch       - Branch name to deploy. (needed by mina/git)
set :application, "public_tracker.com"
set :domain, "112.196.19.154"
set :port, '8979'
set :user, "ubuntu"
set :deploy_to, "/var/www/#{application}"
set :releases_path, 'releases'
set :shared_path, 'shared'
set :current_path, 'current'
set :lock_file, 'deploy.lock'
set :repository, 'git@github.com:gerryats/public-tracker.git'
set :branch, 'master'

# For system-wide RVM install.
#   set :rvm_path, '/usr/local/rvm/bin/rvm'

# Manually create these paths in shared/ (eg: shared/config/database.yml) in your server.
# They will be linked in the 'deploy:link_shared_paths' step.
set :shared_paths, ['config/database.yml', 'config/secrets.yml', 'log']

# Optional settings:
#   set :user, 'foobar'    # Username in the server to SSH to.
#   set :port, '30000'     # SSH port number.
set :forward_agent, true # SSH forward_agent.

# This task is the environment that is loaded for most commands, such as
# `mina deploy` or `mina rake`.
task :environment do
  # If you're using rbenv, use this to load the rbenv environment.
  # Be sure to commit your .ruby-version or .rbenv-version to your repository.
  # invoke :'rbenv:load'

  # For those using RVM, use this to load an RVM version@gemset.
  # invoke :'rvm:use[ruby-1.9.3-p125@default]'
end
RYAML = <<-BASH
function ryaml {
ruby -ryaml -e 'puts ARGV[1..-1].inject(YAML.load(File.read(ARGV[0]))) {|acc, key| acc[key]}' "$@"
};
BASH


# Put any custom mkdir's in here for when `mina setup` is ran.
# For Rails apps, we'll make some of the shared paths that are shared between
# all releases.
task :'setup:all' => :environment do
  queue! %[echo "-----> Setup folder structure on server"]
  invoke :setup

  queue! %[echo "-----> Setup DB Configuration"]
  invoke :'setup:db'

  queue! %[echo "-----> Setup Application Secret"]
  invoke :'setup:secret'

  queue! %[echo "-----> Setup Nginx Configuration"]
  invoke :'setup:nginx'

  queue! %[echo "-----> Setup Unicorn Configuration"]
  invoke :'setup:unicorn'

  queue! %[echo "-----> Deploy Master for this version"]
  invoke :deploy
  invoke :'start:nginx'
  invoke :'start:unicorn'
end
task :setup => :environment do
  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/log"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/log"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/pids"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/pids"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/sockets"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/sockets"]

  queue! %[mkdir -p "#{deploy_to}/#{shared_path}/config"]
  queue! %[chmod g+rx,u+rwx "#{deploy_to}/#{shared_path}/config"]

  queue! %[touch "#{deploy_to}/#{shared_path}/config/database.yml"]
  queue! %[touch "#{deploy_to}/#{shared_path}/config/secrets.yml"]
  # queue  %[echo "-----> Be sure to edit '#{deploy_to}/#{shared_path}/config/database.yml' and 'secrets.yml'."]
  if repository
    repo_host = repository.split(%r{@|://}).last.split(%r{:|\/}).first
    repo_port = /:([0-9]+)/.match(repository) && /:([0-9]+)/.match(repository)[1] || '22'

    queue %[
      if ! ssh-keygen -H  -F #{repo_host} &>/dev/null; then
        ssh-keyscan -t rsa -p #{repo_port} -H #{repo_host} >> ~/.ssh/known_hosts
      fi
    ]
  end
end

task :'setup:db' => :environment do
  puts "Enter a name for the new database"
  db_name = STDIN.gets.chomp
  puts "Enter a user for the new database"
  db_username = STDIN.gets.chomp
  puts "Enter a password for the new database"
  db_password = STDIN.gets.chomp

  database_yml = <<-DATABASE
    production:
        adapter: mysql2
        encoding: utf8
        database: #{db_name}
        username: #{db_username}
        password: #{db_password}
        host: localhost
        timeout: 5000
  DATABASE
  queue! %[
         echo "-----> Populating #{deploy_to}/#{shared_path}/config/database.yml"
         echo "#{database_yml}" > #{deploy_to}/#{shared_path}/config/database.yml
         echo "-----> done."
         ]
end
task :'setup:secret' => :environment do
  secret_yml = <<-SECRET
  production:
    secret_key_base: ca545c4819e7811e760ef84a7b8ae9c541b9d9a8b2dce5b102453fddc86a3bb47de18bfdb3fb547e398dcb5feb398646dcf6bf0762763909d2363d76358023c1

  SECRET
  queue! %[
         echo "-----> Populating #{deploy_to}/#{shared_path}/config/secrets.yml"
         echo "#{secret_yml}" > #{deploy_to}/#{shared_path}/config/secrets.yml
         echo "-----> done."
         ]
end

task :'setup:nginx' => :environment do
  queue "sudo ln -nfs #{deploy_to}/current/config/nginx.conf /etc/nginx/sites-available/public_tracker_com"
  queue "sudo ln -nfs #{deploy_to}/current/config/nginx.conf /etc/nginx/sites-enabled/public_tracker_com"
end

task :'setup:unicorn' => :environment do
  queue "sudo chmod 0775 #{deploy_to}/current/config/unicorn_init.sh"
  queue "sudo ln -nfs #{deploy_to}/current/config/unicorn_init.sh /etc/init.d/unicorn_public_tracker_com"
end

task :'start:nginx' => :environment do
  queue %[
             echo "-----> Starting Nginx Server."
             sudo service nginx start
             echo "-----> done."]
end

task :'start:unicorn' => :environment do
  queue! %[
             cd "#{deploy_to}/#{current_path}"
             bundle install
             echo "-----> Starting Unicorn."
             sudo /etc/init.d/unicorn_public_tracker_com start
             echo "-----> done."]
end

desc "Deploys the current version to the server."
task :deploy => :environment do
  to :before_hook do
    queue "bundle install"
    # Put things to run locally before ssh
  end
  deploy do
    # Put things that will set up an empty directory into a fully set-up
    # instance of your project.
    invoke :'git:clone'
    invoke :'deploy:link_shared_paths'
    invoke :'bundle:install'
    invoke :'rails:db_migrate'
    invoke :'rails:assets_precompile'
    # invoke :'deploy:cleanup'

    to :launch do
      queue "mkdir -p #{deploy_to}/#{current_path}/tmp/"
      queue "touch #{deploy_to}/#{current_path}/tmp/restart.txt"
      queue %[
             echo "-----> Restarting Nginx Server."
             cd #{deploy_to}/#{current_path}/
             RAILS_ENV=production bundle exec rails s &
             echo "-----> done."]
      queue "sudo chmod 0775 #{deploy_to}/current/config/unicorn_init.sh"
      queue! %[
             echo "-----> Restarting Unicorn."
             sudo /etc/init.d/unicorn_public_tracker_com reload
             echo "-----> done."]
      # invoke :'deploy:cleanup'
    end
  end
end

# For help in making your deploy script, see the Mina documentation:
#
#  - http://nadarei.co/mina
#  - http://nadarei.co/mina/tasks
#  - http://nadarei.co/mina/settings
#  - http://nadarei.co/mina/helpers
