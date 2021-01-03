module ApplicationHelper
  def current_user?(user)
    current_user == user
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
