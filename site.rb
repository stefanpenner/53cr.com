require 'rubygems'
require 'sinatra'
require 'haml'
require 'compass'

 
set :public, File.dirname(__FILE__) + '/public' 

get '/' do
  haml :index
end
not_found do
  haml :not_found
end

