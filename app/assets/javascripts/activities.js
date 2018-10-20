$(document).ready(function(){
  var checkbox = document.getElementById("activity_limit_number_participants");
  var detailsDiv = document.getElementById("is-number-participants-limited");
  checkbox.onchange = function() {
    detailsDiv.hidden = !this.checked;
  };
});
