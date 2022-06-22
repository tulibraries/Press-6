// Jumble.js

$(document).ready(function() {  
  $(window).width() < 768 ? mobile() : desktop();

  $(window).resize(function() {  
    $(window).width() < 768 ? mobile() : desktop();
  });
});

function desktop () {
  $('#book-details').appendTo('#book-cover');
  $('#social-share').insertBefore('#book-details');
  $('#book-cover').insertBefore('#right-side');
  $('#book-title').prependTo('#book-info');
}

function mobile () {
  $('#book-details').insertBefore('#book-description');
  $('#book-title').appendTo('#book-cover');
  $('#social-share').appendTo('#book-title');
}