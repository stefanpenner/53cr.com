require 'rubygems'
require 'sinatra'
require 'haml'
require 'compass'
 
get '/' do
  haml :index
end

not_found do
  haml :not_found
end

