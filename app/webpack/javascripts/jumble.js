$(document).ready(function() {  
  $(window).width() < 768 ? mobile() : desktop();

  $('input[type=radio]').click(function(){
    if (this.value == "Exam Copy") {
      document.getElementById("examcopy").style.display = "block";
      document.getElementById("deskcopy").style.display = "none";
      document.getElementById("bookstore").style.display = "none";
      document.getElementById("form_authorized_bookstore").classList.remove("required");
      document.getElementById("form_authorized_bookstore").removeAttribute("required", "required");
      document.getElementById("form_format_ebook").classList.remove("required");
      document.getElementById("form_format_ebook").removeAttribute("required", "required");
      document.getElementById("form_format_ebook").setAttribute("aria-required", "false");
      document.getElementById("form_format_print").classList.remove("required");
      document.getElementById("form_format_print").removeAttribute("required", "required");
      document.getElementById("form_format_print").setAttribute("aria-required", "false");
    }
    if (this.value == "Desk Copy") {
      document.getElementById("examcopy").style.display = "none";
      document.getElementById("deskcopy").style.display = "block";
      document.getElementById("bookstore").style.display = "block";
      document.getElementById("form_authorized_bookstore").classList.add("required");
      document.getElementById("form_authorized_bookstore").setAttribute("required", "required");
      document.getElementById("form_format_ebook").classList.add("required");
      document.getElementById("form_format_ebook").setAttribute("required", "required");
      document.getElementById("form_format_ebook").setAttribute("aria-required", "true");
      document.getElementById("form_format_print").classList.add("required");
      document.getElementById("form_format_print").setAttribute("required", "required");
      document.getElementById("form_format_print").setAttribute("aria-required", "true");
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

