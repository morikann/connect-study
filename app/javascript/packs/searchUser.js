document.getElementById('range').addEventListener('input', (e) => {
  document.getElementById('output').value = e.target.value;
})

document.getElementById('getLocation').addEventListener('click', () => {

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(showPosition);
  } else {
    x.innerHTML = 'このブラウザーはGeolocationをサポートしていません';
  }

  function showPosition(position) {
    const rangeValue = document.getElementById('output').value;
    $.ajax({
      type: 'POST',
      url: '/users/search_user',
      data: {
        latitude: position.coords.latitude,
        longitude: position.coords.longitude,
        range: rangeValue
      }
    })
  }
})

const countProfile = document.querySelectorAll('.count-chip');
countProfile.forEach((tag) => {
  tag.addEventListener('click', (e) => {
    const elm = e.target.firstElementChild.textContent
    $.ajax({
      type: 'GET',
      url: '/users/search_user_from_tag',
      // dataType: 'json',
      data: {
        tag_name: elm
      }
    })
  })
})
