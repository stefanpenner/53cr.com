require 'couch_foo'
require 'maruku'

CouchFoo::Base.set_database(:host => 'http://localhost:5984', :database => 'blog')

class Post < CouchFoo::Base

  property :slug, String
  property :content, String
  property :date, DateTime
  property :author, String
  property :title, String

  def self.find_all_by_month(year,month)
    Post.find(:all)
  end

  def month
    "%02d" % date.month
  end

  def year
    date.year.to_s
  end

  def formatted_date
    date.strftime("%Y-%m-%d")
  end

  def content
    text = read_attribute('content')
    text = code_helper(text)
    puts text
    text = ERB.new(text).result
    text = Maruku.new(text).to_html
    return text
  end

  private
  def code_helper(str)
    str.gsub(/\[code=([^\]]*?)\]\n?(.*?)\n?\[\/code\]/m,
               "<%=code '#{'\1'}', <<'END_SOMELONGSTRING'
#{'\2'}
END_SOMELONGSTRING
%>")
  end
  
end
