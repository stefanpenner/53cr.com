With Ruby 1.9 sneaking up on us, it's probably time to start getting excited about new features, so here goes. Ruby 1.9 has a completely new syntax for lambdas that maps perfectly onto actual [lambda calculus](http://en.wikipedia.org/wiki/Lambda_calculus).

Crash course in lambda calculus: Generally speaking, expressions are specified as "(λ parameters. result) argument", everything is left-associative, and functions are called like "f v", where f is a function and v is a value (or a function…) Thus, the expression:

[code=plain_text]
(λ f. f 3) (λ x. x + 2)
[/code]

evaluates to 5, since the expression on the left consumes a function and calls it with the value 3, while the expression on the right returns its argument plus two. Note that referring to values and functions as two distinct concepts here is technically incorrect, but helps to explain what happens. To do the same thing in Ruby 1.8.7, one would write:

[code=ruby]
# Ruby 1.8.7
lambda{|f| f[3]}[lambda{|x| x+2}]
[/code]

In Ruby 1.9, some new syntactic sugar has been added:

[code=ruby]
# Ruby 1.9
->(f){f.(3)}.(->(x){x+2})
[/code]

The "->" is supposed to be read as a lambda (λ), since relying on unicode characters in code is generally bad news. Not only is this significantly less syntactic overhead than the equivalent code in 1.8.7, it feels less like an ugly hack and more like an acutally-supported feature.

[code=ruby]
# λ x. x
->(x){x}
[/code]

I hope this new lambda syntax encourages more people to write ruby with a more functional style. At the moment, it's certainly an underused 'facet' of ruby.
