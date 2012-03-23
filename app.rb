# encoding: UTF-8
# dev hint: shotgun login.rb

require 'rubygems'
require 'sinatra'
require 'protolink'
require 'yaml'
require 'pony'

configure do
  set :public_folder, Proc.new { File.join(root, "public") }
  enable :sessions
end

configure :development do
  set :development, true
end

before do
  @config = YAML::load(File.open("config.yml"))
end

helpers do
  def protonet
    Protolink::Protonet.open(@config.protonet.host, @config.protonet.user, @config.protonet.pw)
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
  @status = "error"
  
  if settings.development?
    puts "**********"
    puts message_body
    puts "**********"
    @status = "success"
  else
    if params[:newsletter] == true
      
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
  erb :index
end

post '/github' do
  system('git pull origin master && touch tmp/restart.txt')
end

