document.addEventListener('turbolinks:load', () => {
  // クラスがflashMessageの要素を取得
  const flashMessage = document.querySelectorAll('.flash_message');
    flashMessage.forEach((message) => {
      const deleteFlashMessage = () => {
        // 20ミリ秒に一回 opacityを0.01減少させていき、0になったら非表示にしてインターバルを解除する
        const id = setInterval(() => {
          const opacity = message.style.opacity;
    
          if (opacity > 0) {
            message.style.opacity = opacity - 0.01;
          } else {
            message.style.display = 'none';
            clearInterval(id);
          }
        }, 20);
      };
      // flashメッセージが存在する時のみ実行
      if (message) {
        // opacityの初期値を設定
        message.style.opacity = 1;
        // deleteFlashMessageを3000ミリ秒後に実行
        setTimeout(deleteFlashMessage, 3000);
      };
    })
});