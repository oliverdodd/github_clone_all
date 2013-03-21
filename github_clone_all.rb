#!/usr/bin/env ruby
#-------------------------------------------------------------------------------
#  github_clone_all - clone all of your repositories hosted on github
#  
#  requires: json gem and client machine's public key registered on github
#  
#  usage: ./github_clone_all.rb username
#         or enter username at prompt
#-------------------------------------------------------------------------------
require 'rubygems'
require 'open-uri'
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
#response = Net::HTTP.get(URI.parse("https://api.github.com/users/#{username}/repos"))
response = ""
open("https://api.github.com/users/#{username}/repos?per_page=1024") { |io|
  response = io.read
}
repositories = JSON.parse(response)

# clone repositories -----------------------------------------------------------
if repositories.kind_of?(Array)
  puts "found #{repositories.size} repositories"
  repositories.each{ |r|
    repo_name = r["name"]
    repo_addr = "git@github.com:#{username}/#{repo_name}.git"
    puts "\ncloning #{repo_addr}"
    result = %x[git clone #{repo_addr}]
    puts "\t#{result}"
  } 
else
  puts "Error: " + response
end