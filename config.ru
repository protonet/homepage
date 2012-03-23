require 'rubygems'
require 'sinatra'
 
set :public, File.expand_path(File.dirname(__FILE__) + '/public') # Include your public folder
set :views, File.expand_path(File.dirname(__FILE__) + '/views')  # Include the views
 
set :environment, :production
disable :run, :reload

FileUtils.mkdir_p 'log' unless File.exists?('log')
log = File.new("log/sinatra.log", "a")
$stdout.reopen(log)
$stderr.reopen(log)

require './app.rb' # replace this with your sinatra app file
run Sinatra::Application