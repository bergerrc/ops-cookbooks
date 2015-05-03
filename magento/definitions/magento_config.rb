define :magento_config do
  application = params[:application]
  deploy = params[:deploy]

Chef::Log.info("installing #{application}")
Chef::Log.info("path #{application[:current_path]}")

  directory "#{application[:current_path]}/var" do
    group deploy[:group]
    owner deploy[:user]
    mode "0775"
    action :create
    recursive true
  end
  
  directory "#{application[:current_path]}/var/cache" do
    group deploy[:group]
    owner deploy[:user]
    mode "0775"
    action :create
    recursive true
  end
  
  directory "#{application[:current_path]}/var/session" do
    group deploy[:group]
    owner deploy[:user]
    mode "0775"
    action :create
    recursive true
  end

execute "ensure correct permissions for install magento /media /var" do
  command "chmod -R g+w #{application[:current_path]}/media #{application[:current_path]}/var"
  only_if do
    ::File.exists?("#{application[:current_path]}/media")
  end
end

execute "ensure correct permissions for install magento #{application[:current_path]}/var/.htaccess #{application[:current_path]}/app/etc" do
  command "chmod g+w #{application[:current_path]}/app/etc #{application[:current_path]}/var/.htaccess"
  only_if do
    ::File.exists?("#{application[:current_path]}/app/etc")
  end
end
    
if platform?('centos','redhat','fedora','amazon')
  execute 'Run install script of magento' do
    command "php -f #{application[:current_path]}/install.php -- \
--license_agreement_accepted \"yes\" \
--locale \"#{node[:magento][:locale]}\" \
--timezone \"#{node[:magento][:timezone]}\" \
--default_currency \"#{node[:magento][:currency]}\" \
--db_host \"#{application[:database][:host]}\" \
--db_name \"#{application[:database][:database]}\" \
--db_user \"#{node[:magento][:db_username]}\" \
--db_pass \"#{node[:magento][:db_password]}\" \
--db_prefix \"#{node[:database][:db_prefix]}\" \
--url \"#{node[:magento][:url]}\" \
--skip_url_validation \"yes\" \
--use_rewrites \"yes\" \
--use_secure \"no\" \
--secure_base_url \"\" \
--use_secure_admin \"no\" \
--admin_firstname \"#{node[:magento][:admin_firstname]}\" \
--admin_lastname \"#{node[:magento][:admin_lastname]}\" \
--admin_email \"#{node[:magento][:admin_email]}\" \
--admin_username \"#{node[:magento][:admin_username]}\" \
--admin_password \"#{node[:magento][:admin_password]}\""
    action :run
    only_if "/usr/bin/mysql -u #{node[:magento][:db_username]} -p'#{node[:magento][:db_password]}' -e 'show databases;'"
  end
end

end
