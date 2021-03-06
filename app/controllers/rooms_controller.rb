class RoomsController < ApplicationController
  before_action :set_room, only: %i[show event_users]
  
  def index
    @rooms = current_user.rooms.includes([:study_event, users: :profile]).order(created_at: :desc)
  end

  def show
    if Entry.where(room_id: @room.id, user_id: current_user.id).present?
      @messages = @room.messages.includes(user: :profile).order(:id).last(15)
      @message = current_user.messages.build
      @entries = @room.entries.includes(user: :profile)
    else
      redirect_back(fallback_location: root_path)
    end
  end

  def show_additionally
    # room_channel.jsからroom_idを取得
    room = Room.find(params[:room_id])
    first_id = room.messages.first.id
    last_id = params[:oldest_message_id].to_i
    # 取得するメッセージががあるかどうかで条件分岐
    if first_id != last_id 
      # oldest_message_idより前のメッセージの中で最も古いメッセージのid
      next_id = room.messages.where("id < ?", last_id).last.id 
      # 追加で30件取得
      @messages = room.messages.includes(user: :profile).order(:id).where(id: first_id..next_id).last(30)
    else 
      @messages = nil 
    end
  end

  def create
    @room = Room.create 
    currentUserEntry = Entry.create(user_id: current_user.id, room_id: @room.id)
    userEntry = Entry.create(room_params)
    user = User.find(room_params[:user_id])
    user.create_notification_message_room!(current_user)
    redirect_to @room
  end

  def event_users
    @entries = @room.entries.includes(user: :profile)
  end

  private

  def room_params
    params.require(:entry).permit(:user_id).merge(room_id: @room.id)
  end

  def set_room
    @room = Room.find(params[:id])
  end
end
