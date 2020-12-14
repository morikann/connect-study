document.addEventListener('turbolinks:load', () => {
  
  const checkBox = document.getElementById('menu');
  const body = document.body;
  const documentElement = document.documentElement;

  window.addEventListener('scroll', () => {
    // スクロール量を取得
    const scrollAmount = documentElement.scrollTop;
    // サイドバーのクリックイベント
    checkBox.addEventListener('click', (e) => {
      // サイドバーを開いて閉じた際にスクロール位置を変えないように設定
      documentElement.scrollTop = scrollAmount;
      // サイドバーが開いている際は背景を固定
      if (e.target.checked) {
        body.classList.add('move-fixed');
      } else {
        body.classList.remove('move-fixed');
      }
    })
  })
})