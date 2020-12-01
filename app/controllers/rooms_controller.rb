class RoomsController < ApplicationController
  def index
    @rooms = current_user.rooms.includes(:messages).order(created_at: :desc)
  end

  def show
    @room = Room.find(params[:id])
    if Entry.where(room_id: @room.id, user_id: current_user.id).present?
      @messages = @room.messages.includes(user: :profile).order(created_at: :desc)
      @message = Message.new
      @entries = @room.entries
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def create
    @room = Room.create 
    @currentUserEntry = Entry.create(user_id: current_user.id, room_id: @room.id)
    @userEntry = Entry.create(room_params)
    redirect_to @room
  end

  private

  def room_params
    params.require(:entry).permit(:user_id).merge(room_id: @room.id)
  end
end
