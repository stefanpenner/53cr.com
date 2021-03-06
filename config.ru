use Rack::CommonLogger
use Rack::Static, :urls => ["/images", "/javascripts", "/stylesheets"], :root => "public"

require 'jspack'
use Rack::JSPack

map "/blog" do
  require 'blog/site'
  run Blog
end

map "/" do
  require 'site'
  run Site
end
