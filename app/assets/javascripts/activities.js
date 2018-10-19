$(document).ready(function(){
  var checkbox = document.getElementById('activity_limit_number_participants');
  var details_div = document.getElementById('is-number-participants-limited');
  checkbox.onchange = function() {
     if(this.checked) {
       details_div.hidden = false;
     } else {
       details_div.hidden = true;
     }
  };
});
