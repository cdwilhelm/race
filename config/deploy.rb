before "deploy:setup", "db:configure"
after "deploy:update_code", "db:symlink"

set :application, "race"
#set :repository,  "/rails/hpd-2"
set :deploy_to, "/rails/#{application}"
set :user, 'root'
set :use_sudo, true
set :scm, :subversion


role :web, "97.74.121.159"                          # Your HTTP server, Apache/etc
default_run_options[:pty] = true


set :repository,  "https://kenai.com/svn/cwilhelm~sites/trunk/race"
set :svn_username, "curt_wilhelm@yahoo.com"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end


set(:database_username, "race")
# set(:database_password, "root")
set(:development_database) { application + "_development" }
set(:test_database) { application + "_test" }
set(:production_database) { application + "_production" }

namespace :db do
  desc "Create database yaml in shared path"
  task :configure do
    set :database_password do
      Capistrano::CLI.password_prompt "Database Password: "
    end

    db_config = <<-EOF
base: &base
  host: localhost
  port: 3306
  pool: 10
  adapter: mysql
  encoding: utf8
  username: #{database_username}
  password: #{database_password}

development:
  database: #{development_database}
  <<: *base

test:
  database: #{test_database}
  <<: *base

production:
  database: #{production_database}
  <<: *base
EOF

    run "mkdir -p #{shared_path}/config"
    put db_config, "#{shared_path}/config/database.yml"
  end

  desc "Make symlink for database yaml"
  task :symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
  end
end

