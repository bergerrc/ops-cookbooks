define :magento_config do
  application = params[:app]
  deploy = params[:deploy_data]

execute "ensure correct permissions for install magento /media /var" do
  command "chmod -R o+w #{deploy[:deploy_to]}/media #{deploy[:deploy_to]}/var"
  only_if do
    ::File.exists?("#{deploy[:deploy_to]}/media")
  end
end

execute "ensure correct permissions for install magento #{deploy[:deploy_to]}/var/.htaccess #{deploy[:deploy_to]}/app/etc" do
  command "chmod o+w #{deploy[:deploy_to]}/app/etc #{deploy[:deploy_to]}/var/.htaccess"
  only_if do
    ::File.exists?("#{deploy[:deploy_to]}/app/etc")
  end
end
    
if platform?('centos','redhat','fedora','amazon')
  execute 'Run install script of magento' do
    command "php -f install.php -- \
--license_agreement_accepted \"yes\" \
--locale \"#{node[:magento][:locale]}\" \
--timezone \"#{node[:magento][:timezone]}\" \
--default_currency \"#{node[:magento][:currency]}\" \
--db_host \"#{node[:database][:host]}\" \
--db_name \"#{node[:database][:database]}\" \
--db_user \"#{node[:magento][:db_username]}\" \
--db_pass \"#{node[:magento][:db_password]}\" \
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
    only_if "/usr/bin/mysql -u #{node[:magento][:db_username]} -p #{node[:magento][:db_password]} -e 'show databases;'"
  end
end

end
