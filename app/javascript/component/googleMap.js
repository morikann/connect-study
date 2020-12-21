document.addEventListener('turbolinks:load', () => {

  let map;
  let geocoder;
  
  window.initMap = function() {
    geocoder = new google.maps.Geocoder()

    map = new google.maps.Map(document.getElementById('map'), {
      center: { lat: 35.6586, lng: 139.745 },
      zoom: 16
    });

    if(gon.latitude && gon.longitude) {
      
      var latlng = new google.maps.LatLng(gon.latitude, gon.longitude);

      map = new google.maps.Map(document.getElementById('map'), {
        center: { lat: gon.latitude, lng: gon.longitude },
        zoom: 16
      })

      new google.maps.Marker({
        map: map,
        position: latlng
      })
    }
  }

  window.codeAddress = function() {
    let address;
    let address_field;

    address = document.getElementById('address').value;
    address_field = document.getElementById('study-event-address');
  
    geocoder.geocode({ 'address': address }, function(results, status) {
      if (status == 'OK') {
        map.setCenter(results[0].geometry.location);
        marker = new google.maps.Marker({
          map: map,
          position: results[0].geometry.location
        });
        address_field.value = results[0].formatted_address;
      } else {
        alert('該当の結果は見つかりませんでした');
      }
    })
  }


})