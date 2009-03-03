require 'rubygems'
require 'sinatra/base'
require 'haml'
require 'compass'

class Site < Sinatra::Base

  helpers do
    def link_to(text,url)
      "<a href=\"#{url}\">#{text}</a>"
    end
  end

  get '/?' do
    haml :index, :locals => {:body_class => 'home'}
  end

  get '/work/?' do
    haml :work
  end
  
  get '/secret/?' do
    haml :secret, :locals => { :blurb => 'You win the internet!' }
  end
  
  not_found do
    haml :not_found
  end
end
