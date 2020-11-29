module ApplicationHelper
  def current_user?(user)
    current_user == user
  end

  def tags
    # tags = Tag.all 
    # tags.pluck(:name)
    Tag.pluck(:name)
  end
end
