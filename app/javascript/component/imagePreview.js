document.addEventListener('turbolinks:load', () => {
  // 画像をアップロードするinput要素を取得
  document.getElementById('profile_avatar')?.addEventListener('change', (e) => {

    // FileReaderオブジェクトを使用してユーザーのファイルを非同期に読み取る
    const fileReader = new FileReader;
    // 画像の読み込み完了時に処理をする
    fileReader.onload = (e) => {
      // fileReaderによって読み込まれたファイルの文字列を取得
      const dataUri = e.target.result;
      // 画像を表示するimgタグ要素を取得
      const img = document.getElementById('file-preview');
      // src属性にurlを挿入
      img.src = dataUri;
    };
    // 指定されたファイル（ファイルの一つ目）の読み込みをし、完了したらファイルのデータを[data:URL]の文字列でresultに格納する
    fileReader.readAsDataURL(e.target.files[0]);
  })

  document.getElementById('study_event_image')?.addEventListener('change', (e) => {
    
    const fileReader = new FileReader;
    fileReader.onload = (e) => {
      const dataUri = e.target.result;
      const img = document.getElementById('file-preview');
      img.src = dataUri;
    };
    fileReader.readAsDataURL(e.target.files[0]);
  })
})