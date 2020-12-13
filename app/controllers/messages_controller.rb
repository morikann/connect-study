class MessagesController < ApplicationController

  def create 
    if Entry.where(user_id: current_user.id, room_id: message_params[:room_id]).present?
      @message = current_user.messages.build(message_params)
      if @message.save
        gets_entries_all_messages
        ActionCable.server.broadcast "room_channel_#{@room.id}", message: @message.template, message_user_id: current_user.id
        respond_to do |format|
          format.html { redirect_to room_url(message_params[:room_id]) }
          format.js
        end
      else
        flash[:alert] = "メッセージの送信に失敗しました"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id).merge(user_id: current_user.id)
  end

  def gets_entries_all_messages
    @room = Room.find(params[:message][:room_id])
    @messages = @room.messages.includes(user: :profile)
  end
  
end
