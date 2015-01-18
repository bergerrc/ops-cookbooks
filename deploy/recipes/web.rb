include_recipe 'deploy'
include_recipe "nginx::service"

node[:deploy].each do |application, deploy|
  Chef::Log.info("deploying application #{application}")
  Chef::Log.info("path #{deploy[:deploy_to]}")
  Chef::Log.info("user #{deploy[:user]}")
  Chef::Log.info("group #{deploy[:group]}")
  Chef::Log.info("scm: #{deploy[:scm][:scm_type]}")
  
  opsworks_deploy_dir do
    user deploy[:user]
    group deploy[:group]
    path deploy[:deploy_to]
  end

  opsworks_deploy do
    app application
    deploy_data deploy
  end

  nginx_web_app application do
    application deploy
    cookbook "nginx"
  end
end
