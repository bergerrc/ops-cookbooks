node[:deploy].each do |application, deploy|
  if deploy[:application_type] != 'php'
    Chef::Log.debug("Skipping php::configure application #{application} as it is not an PHP app")
    next
  end

  Chef::Log.info("installing #{application}")
  Chef::Log.info("path #{deploy[:deploy_to]}")
  
  magento_config application do
    application deploy
    cookbook "magento"
  end
  
  # write out local.xml
  template "#{application[:current_path]}/app/etc/local.xml" do
    cookbook 'magento'
    source 'local.erb'
    mode '0660'
    owner deploy[:user]
    group deploy[:group]
    variables(
      :database => deploy[:database],
	  :magento => node[:magento]
    )
    only_if do
      File.exists?("#{application[:current_path]}/app/etc")
    end
  end
end
