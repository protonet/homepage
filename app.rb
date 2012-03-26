# encoding: UTF-8
# dev hint: shotgun login.rb

require 'rubygems'
require 'sinatra'
require 'protolink'
require 'yaml'
require 'pony'
require 'net/http'

configure do
  set :public_folder, Proc.new { File.join(root, "public") }
  enable :sessions, :logging
end

configure :development do
  set :development, true
end

before do
  @config = YAML::load(File.open(File.dirname(__FILE__) + "/config.yml"))
end

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
#{(@tel == "" ? "" : "\nTel: #{@tel}")}
     MEEP
  end
  
end

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

post '/contact' do
  
  @name = params[:name]
  @email = params[:email]
  @tel = params[:tel]
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
      if params[:newsletter] == true
        Net::HTTP.post_form(URI.parse("http://protonet.us4.list-manage.com/subscribe/post?u=c9e8e52c812dee7bfd031a95c&amp;id=75b02e1b0a"), {
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
    @name = @email = @tel = @message = nil
  end
  erb :index
end

post '/github' do
  system('cd /home/deploy/protonet/homepage/current && /usr/bin/git pull origin master')
  system('cd /home/deploy/protonet/homepage/current && touch tmp/restart.txt ')
end

