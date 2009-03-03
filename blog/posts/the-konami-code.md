The [jQuery](http://jquery.com/) Team recently updated their web site, causing [quite a stir](http://www.reddit.com/r/programming/comments/6yo56/saddest_redesign_ever/). The most interesting feature of the new site is that it responds to the decades-old [Konami code](http://en.wikipedia.org/wiki/Konami_Code). If you go to [http://jquery.com](http://jquery.com/) and press “↑ ↑ ↓ ↓ ← → ← → B A”, you’re sent to John Resig’s javascript-based guitar hero clone. It’s actually fairly playable.

If you want to implement the Konami code on your website, just include this javascript (written by the jQuery team, not myself).

[code=javascript]
if ( window.addEventListener ) { 
  var kkeys = [], konami = "38,38,40,40,37,39,37,39,66,65"; 
  window.addEventListener("keydown", function(e){ 
    kkeys.push( e.keyCode ); 
    if ( kkeys.toString().indexOf( konami ) >= 0 ) 
      window.location = "http://example.com/"; 
  }, true); 
}
[/code]

Essentially, every time a key is pressed, javascript appends it to an array, then checks the entire array for instances of the konami code. I’d have serious reservations about having this hanging around on any page with text entry, but it’s a fun easter egg for a front page.

**Update 2008-09-01 02:24:**

I’ve modified the code to use an array of 10 elements — the last 10 keys pressed — instead of every key pressed while on the current page. I don’t expect this code would ever have a noticeable impact on performance, whereas the other code could cause problems after the user had typed large amounts of text.

[code=javascript]
if ( window.addEventListener ) { 
  var kkeys = [], konami = "38,38,40,40,37,39,37,39,66,65"; 
  window.addEventListener("keydown", function(e){ 
    kkeys.shift(); 
    kkeys[9] = e.keyCode; 
    if ( kkeys.toString() == konami ) 
      window.location = "http://example.com"; 
  }, true); 
}
[/code]

Using a finite state machine would clearly be a significant performance boost in relative terms, as we’re still comparing strings in this version, but it would take a fair bit more code and nobody would ever notice the performance boost.

**Update 2008-09-05 20:50:**

I reread this post today and realized a finite state machine would actually be painfully simple to implement here, so I’ve done just that. This is the most efficient way I can possibly imagine to listen for the code.

[code=javascript]
if ( window.addEventListener ) { 
  var state = 0, konami = [38,38,40,40,37,39,37,39,66,65]; 
  window.addEventListener("keydown", function(e) { 
    if ( e.keyCode == konami[state] ) state++; 
    else state = 0; 
    if ( state == 10 ) 
      window.location = "http://example.com"; 
  }, true); 
}
[/code]
