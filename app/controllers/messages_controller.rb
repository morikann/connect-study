class MessagesController < ApplicationController

  def create 
    if Entry.where(user_id: current_user.id, room_id: message_params[:room_id]).present?
      @message = Message.new(message_params)
      if @message.save
        flash[:notice] = "メッセージを送信しました"
        redirect_to room_path(message_params[:room_id])
      else
        flash[:alert] = "メッセージの送信に失敗しました"
        redirect_back(fallback_location: root_path)
      end
    end
  end

  def edit 
  end

  def update 
  end

  def destroy 
  end

  private

  def message_params
    params.require(:message).permit(:message, :room_id).merge(user_id: current_user.id)
  end
  
end
