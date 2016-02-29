function initialize() {
  var myLatlng = new google.maps.LatLng(41.561587, -8.397412);
  var mapOptions = {
    zoom: 16,
    center: myLatlng,
    mapTypeId: google.maps.MapTypeId.ROADMAP,
    scrollwheel: false,
    draggable: false
  };

  var map = new google.maps.Map(document.getElementById('map-canvas'), mapOptions);

  var styles = [
  {
    featureType: "all",
    stylers: [
      { hue: "#F6633D" },
      { saturation: -30 }
    ]
  }];
  map.setOptions({styles: styles});

  var contentString = '<p style="line-height: 20px;"><strong>assan Template</strong></p><p>Vailshali, assan City, 302012</p>';

  var infowindow = new google.maps.InfoWindow({
    content: contentString
  });

  /*var marker = new google.maps.Marker({
    position: myLatlng,
    map: map,
    title: 'Marker'
  });

  google.maps.event.addListener(marker, 'click', function() {
    infowindow.open(map, marker);
  });*/
}

google.maps.event.addDomListener(window, 'load', initialize);
