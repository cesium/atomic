function toggleRegistrations(checkbox, detailsDiv){
  var checkbox = document.getElementById(checkbox);
  var detailsDiv = document.getElementById(detailsDiv);

  detailsDiv.hidden = !checkbox.checked;
  checkbox.onchange = function() {
    detailsDiv.hidden = !this.checked;
  };
}

$(document).ready(function(){
  toggleRegistrations("activity_allows_registrations", "allows_registration");
  toggleRegistrations("activity_limit_number_participants", "is-number-participants-limited");
});

