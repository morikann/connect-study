document.addEventListener('turbolinks:load', () => {

  let map;
  let geocoder;
  let marker;
  var latitude = gon.latitude;
  var longitude = gon.longitude;
  
  window.initMap = function() {

    geocoder = new google.maps.Geocoder()
    
    map = new google.maps.Map(document.getElementById('map'), {
      center: { lat: latitude, lng: longitude },
      zoom: 16
    });

    marker = new google.maps.Marker({
      position: { lat: latitude, lng: longitude },
      map: map
    })
  }

  // window.codeAddress = function() {
  //   let address = document.getElementById('address').value;

  //   geocoder.geocode( {'address': address}, function(results, status) {
  //     if (status == 'OK') {
  //       delete marker.position;
  //       delete marker.map
  //       map.setCenter(results[0].geometry.location);
  //       marker = new google.maps.Marker({
  //         map: map,
  //         position: results[0].geometry.location
  //       });
  //       // a.innerHTML = results[0].address_components[3].long_name;
  //     } else {
  //       // alert(status);
  //       alert('該当の結果は見つかりませんでした');
  //     }
  //   })
  // }


})

  