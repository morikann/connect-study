import consumer from "./consumer"

document.addEventListener('turbolinks:load', () => {
  const messagesWrapper = document.getElementById('messages-wrapper');
  const room_id = messagesWrapper.dataset.room_id;
  const channel_user_id = messagesWrapper.dataset.user_id;

  if (messagesWrapper === null) {
    return 
  }

  consumer.subscriptions.create({channel: "RoomChannel", room: room_id }, {
    connected() {
      // Called when the subscription is ready for use on the server
      // console.log('test front');
    },
  
    disconnected() {
      // Called when the subscription has been terminated by the server
    },
  
    received(data) {
      // Called when there's incoming data on the websocket for this channel 
      if (!(data['message_user_id'] == channel_user_id)) {
        messagesWrapper.insertAdjacentHTML('beforeend', data['message']);
      }
    }
  });
})
