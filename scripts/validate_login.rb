#!/usr/bin/ruby1.9.1

require "knj/autoload"
Knj::Os.chdir_file(__FILE__)
require "../include/conf.rb"

data = Knj::Php.json_decode(Knj::Php.base64_decode(ARGV[0]))

if data["server"]["HTTP_X_FORWARDED_FOR"]
	ip = data["server"]["HTTP_X_FORWARDED_FOR"]
else
	ip = data["server"]["REMOTE_ADDR"]
end

session = $db.query("SELECT * FROM knjappserver.sessions WHERE idhash = '#{data["cookie"]["KnjappserverSession"]}' AND ip = '#{ip}' LIMIT 1").fetch

if session[:sess_data].index("ET:user_idi") != nil
	print Knj::Php.json_encode(
		"logged_in" => true
	)
else
	print Knj::Php.json_encode(
		"logged_in" => false
	)
end