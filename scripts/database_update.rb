#!/usr/bin/env ruby1.9.1

require "knj/knj"
Knj.appserver_cli(__FILE__)

script_cmd = "#{Knj::Os.homedir}/Ruby/knjdbrevision/knjdbrevision.rb"
raise "knjdbrevision doesnt exist in #{script_cmd}." if !File.exists?(script_cmd)

script_cmd = "/usr/bin/ruby1.9.1 #{script_cmd}"
script_cmd += " -r #{Knj.dirname(__FILE__)}/../files/database_schema.rb"

_db.opts.each do |key, val|
	script_cmd += " -d #{key}=#{val}"
end

print %x[#{script_cmd}]