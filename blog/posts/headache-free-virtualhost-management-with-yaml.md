Apache VirtualHosts suck.

There, I said it. Apache’s configuration syntax is completely arcane and it’s impossible to avoid massive repetition of code, yet it’s far and away the best option available. It occurred to me the other day, while updating 20-some vhosts manually, that there has to be a better way.

Most of our vhosts fall into one of three categories, variations within which are almost completely limited to replacing the domain name in umpteen lines, so I wrote a templating system. It turned out to be very straightforward. There are two YAML files: one for templates, and one for data. There’s a script to trans-inter-combinify them into Apache VirtualHosts, and a modified apache initscript to run my generator every time Apache is started.

You can grab a copy of the code from the git repo. It’ll almost assuredly take a small amount of modification for your system.

[code=shell-unix-generic]
git clone git://github.com/53cr/generate-vhosts.git 
[/code]

The data file, vhosts.yml, has an extremely concise syntax:

[code=yaml]
--- 
53cr.com: 
  location: 53cr 
redmine.53cr.com: 
  type: rails 
  railsenv: production 
chromium53.com: 
  type: alias 
  redirect: 53cr.com
[/code]

Templates are selected with the ‘type’ attibute, and specified in types.yml. Here’s a sample.

[code=yaml]
--- 
standard: | 
  <VirtualHost *> 
    ServerName    #{@domain} 
    ServerAlias   www.#{@domain} 
    DocumentRoot  /srv/http#{@location}#{@domain}/htdocs 
    RewriteEngine on 
    RewriteCond   %{HTTP_HOST} ^www\\.#{@domain.gsub('.','\.')} 
    RewriteRule   (.*) http://#{@domain}$1 [R=301,L]
    #{@custom} 
  </VirtualHost> 
 
alias: | 
  <VirtualHost *> 
    ServerName        #{@domain} 
    ServerAlias       www.#{@domain} 
    RedirectPermanent / http://#{@redirect}/
  </VirtualHost>
[/code]

There’s really not even a lot of magic to do here. It’s just a simple matter of reading in the vhosts.yml file and applying each item to the template it specifies. I just create a Vhost object, as seen below, from each item in vhosts.yml and concatenate them all into a file that apache reads in.

[code=ruby]
class Vhost 
 
  def initialize(args) 
    args.each do |k,v| 
      instance_variable_set "@#{k}", v 
    end 
    @type ||= 'standard' 
    # We need to wrap @location in slashes, but if it's root,
    # we get // or ///, so we collapse multiple /s to a single /
    @location = "/#{@location}/" 
    @location.gsub!(/\/+/,'/') 
    @types = YAML.load(open("#{CONFIG_PATH}/types.yml")) 
  end 
 
  def to_s 
    if @types.has_key? @type 
      eval("return \"#{@types[@type]}\"") 
    end 
  end 
 
end
[/code]

I also modified my apache initscript to run generate-vhosts each time it reads its configuration. Since Arch Linux initscripts aren’t exactly the pinnacle of portability within the Linux world, I won’t bother posting it here. If you really want a copy, let me know in the comments.
