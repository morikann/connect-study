document.getElementById('range').addEventListener('input', (e) => {
  document.getElementById('output').value = e.target.value;
})

document.getElementById('getLocation').addEventListener('click', () => {

  if (navigator.geolocation) {
    navigator.geolocation.getCurrentPosition(
      showPosition,
      function(error) {
        switch(error.code) {
          case 1:
            alert("位置情報の利用が許可されていません");
            break;
          case 2:
            alert("現在位置が取得できませんでした");
            break;
          case 3:
            alert("タイムアウトになりました");
            break;
          default:
            alert("その他のエラー(エラーコード:"+error.code+")");
            break;
        }
      },
      { timeout:10000 }
    );
  } else {
    alert('このブラウザーはGeolocationをサポートしていません');
  };

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
});

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

