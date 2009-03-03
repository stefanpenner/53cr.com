Cr53 = new Object();

Cr53.konami = function() {
  if ( window.addEventListener ) {
    var state = 0, konami = [38,38,40,40,37,39,37,39,66,65];
    window.addEventListener("keydown", function(e) {
      if ( e.keyCode == konami[state] ) state++;
      else state = 0;
      if ( state == 10 )
        window.location = "http://53cr.com/secret";
    }, true);
  }
};

$(document).ready(function() {

  Cr53.konami();

  //============>>> Contact page.
  if( $("#contact").length > 0 ) {
    // Mandatory field are marked with a '* '.

    var fields = {
      '#name':    '* name',
      '#email':   '* email',
      '#website': 'web address',
      '#message': '* message'
    };

    // Make text disappear on focus and reappear on blur if it wasn't changed.
    $.each(fields, function(sel,text) {
      $(sel).addClass('faded');
      $(sel).focus(function() {
        $(sel).removeClass('faded');
        if($(sel).val() == text) {
          $(sel).val('');
        }
      });
      $(sel).blur(function() {
        if($(sel).val() == '') {
          $(sel).addClass('faded');
          $(sel).val(text);
        }
      });
    });

    // Add some simple form validation.
    $("#submit").click(function() {
      error = false;
      $.each(fields, function(sel,text) {
        if (text.substring(0,1) == '*') { //If this is a required field
          el = $(sel);
          el.removeClass('error');
          if( [text,''].indexOf( el.val() ) != -1) {
            el.addClass('error');
            error = true;
          }
        }
      });

      if(error) { $('#formerrors').slideDown(); }

      return !error;
    });
  }


});
