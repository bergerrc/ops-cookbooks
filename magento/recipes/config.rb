node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping php::configure application #{application} as it is not an PHP app")
    next
  end

  Chef::Log.info("installing #{application}")
  Chef::Log.info("path #{deploy[:deploy_to]}")
  Chef::Log.info("deploy1 #{node[:deploy]}")
  Chef::Log.info("deploy2 #{deploy}")
  
  magento_config application do
    application deploy
    cookbook "magento"
  end

# write out local.xml  
template "#{deploy[:current_path]}/app/etc/local.xml" do
  source "local.erb"
  owner "root"
  group "root"
  mode 0660
    variables(
      :database => deploy[:database],
      :magento => node[:magento]
    )
end

end
