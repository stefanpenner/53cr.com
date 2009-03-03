Ruby has better support for lambdas than most “mainstream” languages, but it’s missing one important feature — a way to reference the lambda itself. Not being able to reference itself makes recursion using a lambda somewhat difficult. For example, say I wanted to define factorial using a recursive lambda. A lot of rubyists would suggest using self.

[code=ruby]
lambda{|n| n.zero? ? 1 : n * self.call(n-1)}
[/code]

Unfortunately, self is evaluated in the context of the calling block, so it doesn’t return the lambda as you might hope; it returns main or whatever context you’re calling the lambda from, usually resulting in an error, or at least not what you were hoping for. The only way, as far as I can tell, to reference the lambda is by assigning it to a variable:

[code=ruby]
fac = lambda{|n| n.zero? ? 1 : n * fac.call(n-1)} 
[/code]

Again, this is not ideal. Not only does it pollute the calling context, it relies on the variable name it’s assigned to. It works, but it’s ugly. The only solution I’ve been able to come up with is to wrap it in another lambda:

[code=ruby]
# Ruby 1.8.7
lambda{|n| (fac=lambda{|n| n.zero? ? 1 : n * fac.call(n-1)}).call(n) }
 
# Ruby 1.9
->(n){(fac=->(n){n.zero? ? 1 : n * fac.(n-1)}).(n)}
[/code]

This is better from a purity standpoint, but it’s still ugly code. I’ve heard talk of some way to reference the current block in upcoming versions of Ruby, but I haven’t been able to find any concrete information on the subject. If anyone has news, let me know.

**Update 2008-10-06 20:42**

Apparently what I was looking for here is the Y combinator. Nex3 does a far better job of explaining it than I could hope to, but here’s the code to make it happen:

[code=ruby]
def Y 
  lambda { |f| f.call(f) }.call( 
    lambda do |g| 
      yield(lambda { |*n| g.call(g).call(*n) }) 
    end) 
end 
 
Y { |this| lambda { |n| n == 0 ? 1 : n * this.call(n - 1) } }.call(12) 
#=> 479001600
[/code]

Thanks to sjs for pointing this out.
