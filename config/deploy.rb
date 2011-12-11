before "deploy:setup", "db:configure"
before "deploy:restart","deploy:extra_symlink", "deploy:migrate"
after "deploy:restart","deploy:cleanup"

set :application, "race"
set :deploy_to, "/rails/#{application}"
set :user, 'root'
set :use_sudo, true
set :scm, :subversion
set :rails_env, "production"

role :web, "97.74.121.159"                          # Your HTTP server, Apache/etc
role :db, "97.74.121.159",:primary=>true 
default_run_options[:pty] = true


set :repository,  "https://kenai.com/svn/cwilhelm~sites/trunk/race"
set :svn_username, "curt_wilhelm@yahoo.com"

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :web, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  desc "Make symlinks"
  task :extra_symlink do
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
    run "ln -nfs #{shared_path}/images/events #{latest_release}/public/images/events"
    run "ln -nfs #{shared_path}/config/database.yml #{latest_release}/config/database.yml"
    run "mkdir -p #{latest_release}/tmp/attachment_fu;chown -R nobody:nobody #{latest_release}/tmp/attachment_fu"
    run "touch #{latest_release}/log/#{rails_env}.log;chmod 666 #{latest_release}/log/#{rails_env}.log"
  end

end


set(:database_username, "race")
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
    run "mkdir -p #{shared_path}/images/events; chown -R nobody:nobody #{shared_path}/images/events"
    #run "mkdir -p #{shared_path}/images/ads; chown -R nobody:nobody #{shared_path}/images/ads"
    put db_config, "#{shared_path}/config/database.yml"
  end

end

