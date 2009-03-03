Randall Munroe of [XKCD](http://xkcd.com) fame has said on multiple occasions that he chose the name XKCD mostly at random, considering only that it’s an unpronounceable combination of letters that hadn’t been previously used in any significant way. I’m not so sure. I’m apparently [not the first one](http://shortminds.com/2008/08/11/explaining-greatnes/) to realize this, but if you take A=1, B=2, and so on, adding up the values of XKCD gives [42](http://en.wikipedia.org/wiki/Answer_to_Life,_the_Universe,_and_Everything).

I figured this out while I was playing around with [Reg Braithwaite’s](http://reginald.braythwayt.com/) wonderful [String\#to\_proc](http://raganwald.com/source/string_to_proc.rb.html) library. Here’s the code I used.

[code=ruby]
[?x,?k,?c,?d].map(&'_-96').fold(&'+')
[/code]

In short, this generates an array of the ascii values for the letters x, k, c, and d, converts them from a=97 to a=1, then sums them. Unlike Symbol#to\_proc, which is standard in recent versions of ruby, String#to\_proc substitutes underscores with the current value.
