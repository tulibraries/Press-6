$(document).ready(function() {  
  $(window).width() < 768 ? mobile() : desktop()
  $('#form_requested_books').change(function(event) {;
    var last_valid_selection = null;
    if ($(this).val().length > 3) {
      console.log(last_valid_selection);
      last_valid_selection = $(this).val();
      // $('#form_requested_books').val(last_valid_selection);
    } else {
      last_valid_selection = $(this).val();
      console.log(last_valid_selection);
    }
  });
});
$(window).resize(function() {  
  $(window).width() < 768 ? mobile() : desktop();
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

