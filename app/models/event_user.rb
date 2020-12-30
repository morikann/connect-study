class EventUser < ApplicationRecord
  belongs_to :user

  # 勉強会への参加を拒否したことを通知する
  def create_notification_reject!(current_user, visited_id, study_event_id, request_notification_id)
    notification = current_user.active_notifications.build(
      visited_id: visited_id,
      study_event_id: study_event_id,
      action: 'reject_request'
    )
    notification.save if notification.valid?
    # 参加申し込みの通知は削除する
    request_notification = Notification.find(request_notification_id)
    request_notification.destroy
  end

  # 勉強会への参加を承認したことを通知する
  def create_notification_approve!(current_user, visited_id, study_event_id, request_notification_id)
    notification = current_user.active_notifications.build(
      visited_id: visited_id,
      study_event_id: study_event_id,
      action: 'approve_request'
    )
    notification.save if notification.valid?
    # 参加申し込みの通知は削除する
    request_notification = Notification.find(request_notification_id)
    request_notification.destroy
  end
end
