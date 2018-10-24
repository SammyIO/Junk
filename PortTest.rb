require 'rubygems'
require 'net/ldap'
require 'io/console'

puts "User name for LDAP"
user_name = gets
puts "Password for LDAP"
PassW = STDIN.noecho(&:gets)
ldap = Net::LDAP.new
ldap.host = "iam-vault1-prod.it.ad.flinders.edu.au"
ldap.port = 389
ldap.auth user_name, PassW
ldap.base = "ou=active,ou=people,o=data" 
if ldap.bind
  puts "Connection successful!  Code:  #{ldap.get_operation_result.code}, message: #{ldap.get_operation_result.message}"
else
  puts "Connection failed!  Code:  #{ldap.get_operation_result.code}, message: #{ldap.get_operation_result.message}"
end