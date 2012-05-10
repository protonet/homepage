# encoding: UTF-8
# dev hint: shotgun app.rb

require 'rubygems'
require 'sinatra'
require 'protolink'
require 'yaml'
require 'pony'
require 'net/http'
require 'sinatra/r18n'

###############
# configuration
###############

configure do
  set :public_folder, Proc.new { File.join(root, "public") }
  enable :sessions, :logging
  set :default_locale, 'de'
end

configure :development do
  set :development, true
end

########
# helper
########

helpers do
  def protonet
    Protolink::Protonet.open(@config["protonet"]["host"], @config["protonet"]["user"], @config["protonet"]["pw"])
  end
  
  def sales
    protonet.find_channel_by_name("sales")
  end
  
  def message_body 
    <<-MEEP
Neue Nachricht von der Website:
#{@name} <#{@email}>
#{@message}
     MEEP
  end
  
  def preferred_language
    env['HTTP_ACCEPT_LANGUAGE'].scan(/^(..)/).flatten.first
  rescue # Just rescue anything if the browser messed up badly.
    'de'
  end
  
end

########
# before
########

before do
  @config = YAML::load(File.open(File.dirname(__FILE__) + "/config.yml"))
  session[:locale] = params[:lang] if params[:lang]
  session[:locale] ||= preferred_language
end

########
# static 
########

get '/' do 
  @index = true
  erb :index
end

get '/team' do 
  @team = true
  erb :team
end

get '/newsletter' do 
  erb :newsletter
end

get '/impressum' do
  erb :imprint
end

get '/datenschutz' do
  erb :privacy
end

post '/contact' do
  
  @name = params[:name]
  @email = params[:email]
  @message = params[:message]
  @index = true
    
  if @name.nil? || @name.empty? || @email.nil? || 
    @email.empty? || !@email.match(/\A[^@]+@([^@\.]+\.)+[^@\.]+\z/) 
  then
    @status = "Bitte überprüfen Sie Ihre Angaben."
  else
    if settings.development?
      puts "**********"
      puts message_body
      puts "**********"
      @status = "success"
    else
      @status = "Ups. Da ist etwas schiefglaufen"
      if params[:newsletter]
        respose = Net::HTTP.post_form(URI.parse("http://protonet.us4.list-manage.com/subscribe/post?u=c9e8e52c812dee7bfd031a95c&id=75b02e1b0a"), {
          "EMAIL" => @email
        })
      end
      begin 
        sales.speak(message_body)
        @status = "success"
      rescue
        if Pony.mail( :to => "henning@protonet.info",
             :from => "#{@email}",
             :subject => "#{@name} via protonet.info",
             :body => message_body
           ) 
          @status = "success"
        end
      end
    end
  end
  if @status == "success"
    @name = @email = @message = nil
  end
  erb :index
end

###################
# github deployhook
###################

post '/github' do
  system('cd /home/protonet/homepage/current && /usr/bin/git pull origin master')
  system('cd /home/protonet/homepage/current && touch tmp/restart.txt ')
end

