class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.includes([:study_event, visitor: :profile]).page(params[:page])
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def attend_request
    duplicate_notification = Notification.where(
      visitor_id: current_user.id,
      study_event_id: notification_params[:study_event_id], 
      action: 'attend_request'
    )
    # 同じ勉強会への参加申請が連続して送信された場合リダイレクトさせる
    if duplicate_notification.exists?
      flash[:alert] = "すでに参加希望の申請は完了しています"
      return redirect_to study_event_path(notification_params[:study_event_id])
    end

    notification = current_user.active_notifications.build(notification_params)
    event_user = EventUser.where(user_id: current_user.id, study_event_id: notification_params[:study_event_id])
    # 申し込むユーザーがすでに勉強会に参加しているかどうか判定
    if event_user.blank?
      if notification.save
        flash[:notice] = "参加希望の申請が完了しました"
        redirect_to study_event_path(notification_params[:study_event_id])
      else
        flash[:alert] = "参加希望の申請に失敗しました"
        redirect_to study_event_path(notification_params[:study_event_id])
      end
    else
      flash[:alert] = "すでに参加しています"
      redirect_to study_event_path(notification_params[:study_event_id])
    end
  end

  private

  def notification_params
    params.require(:notification).permit(:visited_id, :action, :study_event_id)
  end
end
