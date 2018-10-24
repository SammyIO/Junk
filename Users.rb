# Dirty POC script
require 'rubygems'
require 'roo'
require 'csv'
require 'net/ldap'
require 'io/console'
require 'openSSL'

#Get credentials - PW hidden on display
puts "User name for LDAP"
user_name = gets
puts "Password for LDAP"
PassW = STDIN.noecho(&:gets)

#LDAP params
host = "iam-vault1-prod.it.ad.flinders.edu.au"
port = 389
base = "ou=active,ou=people,o=data"
credentials = {
    :method => :simple,
    :username => user_name.chomp ,
    :password => PassW.chomp ,
}
ctx = OpenSSL::SSL::SSLContext.new
ctx.ssl_version = :TLSv1_2

fan_array = []
results_csv_array = []
#Creates a search array from a CSV of users
#TODO create method to extract users from .xlsx - for now this is fine
puts Dir.pwd
Book = CSV.foreach("U:/MyWork/Ruby/FANs_for_TeamUsers.CSV",:skip_blanks => true) do |row|
    fan_array.push(row)
end

#Open LDAP connection and search for each fan, and stick teh returned attributes into an array as a string.

Net::LDAP.open(:host=>host, :port => port, :encryption => :simple_tls, :base => base, :auth => credentials ) do |ldap|
    for fan in fan_array
        seach_param = fan
        result_attrs = ["uid", "fullName", "flindersPersonAcademicGen", "flindersPersonSponsoredRoles", "title"]
        search_filter = Net::LDAP::Filter.eq("uid",seach_param)
        ldap.search( :base => base, :filter => search_filter, :attributes => result_attrs) do |item|
            results_array.push("#{item.uid.first}: #{item.fullName.first}: #{item.flindersPersonAcademicGen.first}: #{item.flindersPersonSponsoredRoles.first}: #{item.title.first}")
        end
    end
end

#Build CSV from the array with each element a new line
#Will require post output clean up in Excel
#TODO get this to spit out as a table without needing the post clean up - clean up the above .push. 

CSV.generate("output.csv","w") do |csv|
    results_array.each do |array|
        csv << array
    end
end
