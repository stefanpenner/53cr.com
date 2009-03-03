require 'sinatra/base'
require 'uv'
Dir.glob(File.join(File.dirname(__FILE__),'lib/*')).each do |entry|
  require entry
end

class Blog < Sinatra::Base
  set :root, File.dirname(__FILE__)

  set :views,  File.dirname(__FILE__) + '/../views'
  set :public, File.dirname(__FILE__) + '/../public'
  
  helpers do
    def path_is(path)
      actual_path = request.env["REQUEST_URI"]
      (return false unless actual_path == path) if path == '/'
      return actual_path.slice(0,path.size) == path
    end
    def link_to(text,url)
      "<a href='#{url}'>#{text}</a>"
    end
    def blog_link(text,url)
      "<a href='/blog#{url}'>#{text}</a>"
    end
  end

  def code(lang,text,linenums=true)
    puts lang
    puts text
    Uv.parse(text,"xhtml",lang,linenums,'sunburst')
  end

  def valid?(params)
    year, month, slug = params[:year], params[:month], params[:slug]
    return false if year  and year  !~ /\d{4}/ # Valid year format
    return false if month and month !~ /\d{2}/ # Valid month format
    if year and month and slug # Permalink
      post = Post.find_by_slug(slug)
      return false unless post # Wrong slug
      return false if year  != post.year 
      return false if month != post.month
    end
    return true
  end

  # Index
  get "/?" do
    posts = Post.find(:all)
    haml "blog/post_list".to_sym, :locals => {:posts => posts}
  end

  # RSS Feed
  get "/feed/rss/?" do
    posts = Post.find(:all)
    "feed!"
  end

  # Permalink
  get "/:year/:month/:slug/?" do
    pass unless valid? params
    post = Post.find_by_slug(params[:slug])
    haml "blog/post_view".to_sym, :locals => {:post => post}
  end

  # Show archive for month
  get "/:year/:month/?" do
    pass unless valid? params
    posts = Post.find(:all)
    haml "blog/post_list".to_sym, :locals => {:posts => posts}
  end

  # Show posts matching tag
  # FIXME
  get "/tag/:tag/?" do
    "TODO"
  end

  not_found do
    "404"
  end
end
