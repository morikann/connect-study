class EventUsersController < ApplicationController

  def create
    @event_user = EventUser.new(
      user_id: event_user_params[:user_id],
      study_event_id: event_user_params[:study_event_id]
    )
    user = User.find(event_user_params[:user_id])
    # 参加を拒否した場合はレコードを作成せず、拒否されたことを相手に通知してリダイレクトする
    if params[:reject]
      # 勉強会への参加を拒否したことを通知する
      @event_user.create_notification_reject!(current_user, event_user_params[:user_id], event_user_params[:study_event_id], event_user_params[:request_notification_id])
      flash[:notice] = "#{user.profile.username}さんの勉強会への参加を拒否しました"
      return redirect_to notifications_path
    end

    if @event_user.save
      # 勉強会への参加を承認したことを通知する
      @event_user.create_notification_approve!(current_user, event_user_params[:user_id], event_user_params[:study_event_id], event_user_params[:request_notification_id])
      flash[:notice] = "#{user.profile.username}さんの勉強会への参加を承認しました"
      redirect_to notifications_path
    else
      flash[:alert] = "#{user.profile.username}さんの勉強会への参加の承認ができませんでした"
      redirect_to notifications_path
    end
  end

  private

  def event_user_params
    params.require(:event_user).permit(:user_id, :study_event_id, :request_notification_id)
  end
end
