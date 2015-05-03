###
# Do not use this file to override the php cookbook's default
# attributes.  Instead, please use the customize.rb attributes file,
# which will keep your adjustments separate from the AWS OpsWorks
# codebase and make it easier to upgrade.
#
# However, you should not edit customize.rb directly. Instead, create
# "php/attributes/customize.rb" in your cookbook repository and
# put the overrides in YOUR customize.rb file.
#
# Do NOT create an 'php/attributes/default.rb' in your cookbooks. Doing so
# would completely override this file and might cause upgrade issues.
#
# See also: http://docs.aws.amazon.com/opsworks/latest/userguide/customizing.html
###

include_attribute 'deploy'

include_attribute "php::customize"

default[:magento][:currency] = "BRL"
default[:magento][:timezone] = "America/Sao_Paulo"
default[:magento][:locale] = "pt_BR"
default[:magento][:db_username] = "root"
default[:magento][:db_password] = "pZbEXTIbtxz4R1YLCgGD_"
default[:magento][:table_prefix] = "magento_"
default[:magento][:crypt_key] = ""
default[:magento][:install_date] = ""
default[:magento][:url]  = "http://dev.jujubiartes.com.br"
default[:magento][:admin_firstname] = "eCommerce"
default[:magento][:admin_lastname] = "Administrator"
default[:magento][:admin_email] = "suporte@jujubiartes.com.br"
default[:magento][:admin_username] = "admin"
default[:magento][:admin_password] = "admin2015"
default[:database][:host] = "localhost"
default[:database][:db_prefix] = "magento_"
