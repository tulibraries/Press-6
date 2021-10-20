$(function() {
  // initialize the Selectize control
  var $select = $('select').selectize({});

  // fetch the instance
  var selectize = $select[0].selectize; // 0 for select index
  selectize.refreshOptions(false); // populate option on load
});
