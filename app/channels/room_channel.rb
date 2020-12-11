class RoomChannel < ApplicationCable::Channel
  def subscribed
    # puts params[:room]
    # puts params
    stream_from "room_channel_#{params[:room]}"
    # 5.times { puts 'test' }

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
