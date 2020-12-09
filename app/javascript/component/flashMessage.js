document.addEventListener('turbolinks:load', () => {
  // クラスがflashMessageの要素を取得
  const flashMessage = document.querySelector('.flash_message');
  const deleteFlashMessage = () => {
    // 20ミリ秒に一回 opacityを0.01減少させていき、0になったら非表示にしてインターバルを解除する
    const id = setInterval(() => {
      const opacity = flashMessage.style.opacity;

      if (opacity > 0) {
        flashMessage.style.opacity = opacity - 0.01;
      } else {
        flashMessage.style.display = 'none';
        clearInterval(id);
      }
    }, 20);
  };
  // flashメッセージが存在する時のみ実行
  if (flashMessage) {
    // opacityの初期値を設定
    flashMessage.style.opacity = 1;
    // deleteFlashMessageを3000ミリ秒後に実行
    setTimeout(deleteFlashMessage, 3000);
  };
});