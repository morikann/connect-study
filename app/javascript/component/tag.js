document.addEventListener("turbolinks:load", () => {

  // input要素を取得
  const inputTags = document.getElementById('tag-input');
  // プレビューするタグの親要素を取得
  const container = document.getElementById('tag-wrap');

  // 内容が変わりfocusが外れたときにイベントを発火
  inputTags.addEventListener('change', (e) => {
    // 既存のプレビューしている要素があった時は一つずつ削除
    if(container.firstChild) {
      while(container.firstChild) {
        container.removeChild(container.firstChild);
      };
    };

    // イベントが発火した要素の値を空白で区切り、配列にする
    array = e.target.value.split(' ');
    // 値が入力されている時のみ
    if(e.target.value) {
      // プレビューする親要素に一つずつ追加
      for(const value of array) {
        const divElement = document.createElement('div');
        divElement.classList.add('chip');
        divElement.innerHTML = value;
        container.appendChild(divElement);
      };
    };
  });
});