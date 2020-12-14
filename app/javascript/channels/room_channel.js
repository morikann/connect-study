import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  // js.erbでも使えるようにグローバル変数として定義
  window.messagesWrapper = document.getElementById('messages-wrapper');

  if (messagesWrapper === null) {
    return 
  }

  const room_id = messagesWrapper.dataset.room_id;
  const channel_user_id = messagesWrapper.dataset.user_id;

  consumer.subscriptions.create({channel: "RoomChannel", room: room_id }, {
    connected() {
      // Called when the subscription is ready for use on the server
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      // Called when there's incoming data on the websocket for this channel 
      if (data['message_user_id'] != channel_user_id) {
        messagesWrapper.insertAdjacentHTML('beforeend', data['message']);
        // メッセージを受け取った際に一番下にスクロールさせる
        scrollToBottom();
      };
    },
  });

  const documentElement = document.documentElement;
  // views/messages/create.js.erb内でも使えるようにグローバルとして関数として定義
  window.scrollToBottom = () => {
    window.scroll(0, documentElement.scrollHeight)
  };
  // ページを表示した際に一番下にスクロールさせる
  scrollToBottom();

  // views/messages/create.js.erbでも使えるようにグローバル変数として定義
  window.messageTextarea = document.getElementById('message-textarea');
  const messageBtn = document.getElementById('message-btn');

  // 最初は送信できないようにしておく
  messageBtn.disabled = true;

  const btnActivation = () => {
    if (messageTextarea.value === '') {
      messageBtn.disabled = true;
    } else {
      messageBtn.disabled = false;
    };
  };

  // フォームに入力した際の動作
  messageTextarea.addEventListener('input', () => {
    // 文字が入力されたら送信できるようにする
    btnActivation();
    // 改行したときにメッセージが見えなくなるのを防ぐために一番下にスクロールさせる
    scrollToBottom();
  })

  const messageForm = document.getElementById('message-form');
  // メッセージを送信した後にボタンを押せないようにする(これをしないと送信した後の空のテキストエリアでも送信できてしまう)
  messageForm.addEventListener('submit', () => {
    messageBtn.disabled = true;
  })

  let oldestMessageId;
  // メッセージの追加読み込みの可否を決定する変数
  window.showAdditionally = true;

  window.addEventListener('scroll', () => {
    if (documentElement.scrollTop === 0 && showAdditionally) {
      showAdditionally = false;
      // 表示済みメッセージの中で最も古いものを取得
      oldestMessageId = document.getElementsByClassName('message')[0]?.id
      $.ajax({
        type: 'GET',
        url: '/show_additionally',
        cache: false,
        data: {
          room_id: room_id,
          oldest_message_id: oldestMessageId,
          // remote: true
        }
      })
    }
  }, { passive: true });
})
