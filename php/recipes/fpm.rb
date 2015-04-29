package 'php-fpm'

service 'php-fpm' do
  action [:enable, :start]
end
