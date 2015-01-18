include_recipe 'deploy'
include_recipe "nginx::service"

node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'static' && deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping deploy::web application #{application} as it is not an static HTML or PHP app.")
    next
  end
  
  Chef::Log.info("deploying application #{application}")
  Chef::Log.info("path #{deploy[:deploy_to]}")
  Chef::Log.info("user #{deploy[:user]}")
  Chef::Log.info("group #{deploy[:group]}")
  if !deploy[:scm].nil?
    Chef::Log.info("scm: #{deploy[:scm][:scm_type]}")
  end
  if !deploy[:domains].nil?
    deploy[:domains].each do |d|
      Chef::Log.info("domain: #{d}")
    end 
  end
  
  
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
