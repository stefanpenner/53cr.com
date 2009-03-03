require 'jsmin'
require 'packr'

module Rack
  class JSPack
    F = ::File

    def initialize(app, options={})
      @app = app
      @src = options.delete(:src) || 'public/javascripts'
      @target = options.delete(:target) || 'jspack'
      @method = options.delete(:method) || 'jsmin'
    end

    def call env
      if (env["REQUEST_URI"] =~ /^\/#{@target}\//)
        path = env["REQUEST_URI"].sub(/^\/#{@target}\//,'')
        path.sub!(/\.js$/,'')

        # now the path should be of the form jQuery+site+jquery.tooltip
        files = path.split('+')

        output = ""

        files.each do |file|
          path = F.join(@src, "#{F.basename(file)}.js")
          next if !F.exists?(path)
          output << F.read(path)
          output << "\n"
        end

        if @method == 'packr'
          output = Packr.pack(output)
        elsif @method == 'jsmin'
          output = JSMin.minify(output)
        end
        
        @status = 200
        @headers = { "Content-Type" => "text/javascript",
          "Content-Length" => output.size.to_s }
        @body = output
      else
        @status, @headers, @body = @app.call(env)
      end
      [@status, @headers, @body]
    end
  end
end
