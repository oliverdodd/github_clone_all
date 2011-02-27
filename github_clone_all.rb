#!/usr/bin/env ruby
#-------------------------------------------------------------------------------
#  github_clone_all - clone all of your repositories hosted on github
#  
#  requires: json gem and client machine's public key registered on github
#  
#  usage: ./github_clone_all.rb username
#         or enter username at prompt
#-------------------------------------------------------------------------------

require 'net/http'
require 'rubygems'
require 'json'

# get username -----------------------------------------------------------------
username = ""
if ARGV[0] then
  username = ARGV[0]
else
  print "github username: "
  while (c = STDIN.getc).chr != "\n"
    username += c.chr
  end
end

# get repositories -------------------------------------------------------------
response = Net::HTTP.get(URI.parse("http://github.com/api/v2/json/repos/show/#{username}"))
reponseObject = JSON.parse(response)

repositories = reponseObject["repositories"]
error = reponseObject["error"]

# clone repositories -----------------------------------------------------------
if repositories
  puts "found #{repositories.size} repositories"
  repositories.each{ |r|
    repo_name = r["name"]
    repo_addr = "git@github.com:#{username}/#{repo_name}.git"
    puts "\ncloning #{repo_addr}"
    result = %x[git clone #{repo_addr}]
    puts "\t#{result}"
  } 
elsif error
  puts "Error: " + error
else
  puts "Unknown Error: " + response
end