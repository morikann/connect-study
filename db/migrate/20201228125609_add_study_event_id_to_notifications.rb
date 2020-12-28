class AddStudyEventIdToNotifications < ActiveRecord::Migration[6.0]
  def up
    add_column :notifications, :study_event_id, :integer
  end

  def down 
    remove_column :notifications, :study_event_id, :integer 
  end 
end
