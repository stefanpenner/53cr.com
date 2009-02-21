require 'rubygems'
require 'sinatra'
require 'haml'
require 'compass'
 
configure do
  Compass.configuration do |config|
    config.project_path = File.dirname(__FILE__)
    config.sass_dir     = File.join('views', 'stylesheets')
  end
end

set :public, File.dirname(__FILE__) + '/public' 

get "/stylesheets/screen.css" do
  content_type 'text/css'
  # Use views/stylesheets & blueprint's stylesheet dirs in the Sass load path
  sass :"stylesheets/screen", :sass => Compass.sass_engine_options
end


get '/' do
  haml :index
end

