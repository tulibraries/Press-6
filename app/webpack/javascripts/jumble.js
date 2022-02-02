$(document).ready(function() {  
  $(window).width() < 768 ? mobile() : desktop();

  $('input[type=radio]').click(function(){
    if (this.value == "Exam Copy") {
      document.getElementById("examcopy").style.display = "block";
      document.getElementById("deskcopy").style.display = "none";
    }
    if (this.value == "Desk Copy") {
      document.getElementById("examcopy").style.display = "none";
      document.getElementById("deskcopy").style.display = "block";
    }
  });

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

