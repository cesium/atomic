$(document).ready(function(){
  var checkbox = document.getElementById('activity_limit_number_participants');
  var details_div = document.getElementById('is-number-participants-limited');
  checkbox.onchange = function() {
    details_div.hidden = !this.checked
  };
});
