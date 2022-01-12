$(document).ready(function() {  
  $(window).width() < 768 ? mobile() : desktop();
});
$(window).resize(function() {  
  $(window).width() < 768 ? mobile() : desktop();
});

function desktop () {
  $('#book-details').insertAfter('#social-share');
  $('#social-share').insertBefore('#book-details');
  $('#book-cover').insertBefore('#book-info');
}

function mobile () {
  $('#book-details').insertBefore('#book-description');
  $('#social-share').appendTo('#book-cover');
}

