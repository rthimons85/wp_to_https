require 'optparse'
require 'rubygems'
require 'highline/import'
require 'mysql2'

options = {}

OptionParser.new do |parser|
	
	parser.on("-u", "--user USER", "Database user") do |v|
		options[:dbuser] = v
	end
	parser.on("-h", "--host HOSTNAME", "MySQL host") do |v|
		options[:dbhost] = v
	end
	parser.on("-d", "--database DATABASE", "MySQL database") do |v|
		options[:dbname] =  v
	end
	parser.on("-p", "--password", "Use MySQL password.(you will be prompted for a password later)") do |v|
		options[:dbpass] = v
	end
	parser.on("-D", "--Domain DOMAIN", "wordpress domain") do |v|
		options[:wpdomain] = v
	end

end.parse!

dbname = options[:dbname]
if options[:dbpass]
	pass = ask('Enter Password') { |q| q.echo = false }
	database = Mysql2::Client.new(:host => options[:dbhost], :username => options[:dbuser], :password => pass, :database => dbname)
	results = database.query("update wp_posts set post_content = REPLACE(post_content, 'http://#{options[:wpdomain]}', 'https://#{options[:wpdomain]}') where post_content like '%http://#{options[:wpdomain]}%'")
end
