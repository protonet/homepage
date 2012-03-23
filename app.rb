# encoding: UTF-8
# dev hint: shotgun login.rb

require 'rubygems'
require 'sinatra'
require 'protolink'
require 'yaml'
require 'net/http'

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

  if settings.development?
    puts "**********"
    puts "#{name} <#{email}>"
    puts message + (tel == "" ? "" : "\nTel: #{tel}")
    puts "**********"
    redirect "/?status=success"
  else
    if params[:newsletter] == true
      
    end
    begin 
      sales.speak(
        <<-MEEP
#{@name} <#{@email}>
#{@message}
#{(@tel == "" ? "" : "\nTel: #{@tel}")}
        MEEP
      )
      @status = "success"
    rescue
      @status = "error"
    end
    erb :index
  end
end

