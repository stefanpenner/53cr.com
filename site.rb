require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'compass'

class Site < Sinatra::Base
  get '/?' do
    haml :index
  end

  not_found do
    haml :not_found
  end
end
