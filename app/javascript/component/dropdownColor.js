document.addEventListener('turbolinks:load', () => {
  // select-dropdownクラスの要素を全て取得
  const dropdownList = document.querySelectorAll('.select-dropdown');
  const drop = document.getElementsByClassName('select-dropdown');
  // 各.select-dropdownに対してループ
  dropdownList.forEach((dropdown) => {
    // クリックされた要素は色を変更
    dropdown.addEventListener('click', (e) => {
      e.target.style.color = "#262626";
    });
  });
});