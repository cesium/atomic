$(document).ready(function(){
  toggle_registrations;
  toggle_registrations("activity_allows_registrations", "allows_registration");
  toggle_registrations("activity_limit_number_participants", "is-number-participants-limited");
});

function toggle_registrations(checkbox, detailsDiv){
  var checkbox = document.getElementById(checkbox);
  var detailsDiv = document.getElementById(detailsDiv);

  detailsDiv.hidden = !checkbox.checked;
  checkbox.onchange = function() {
    detailsDiv.hidden = !this.checked;
  };
}
