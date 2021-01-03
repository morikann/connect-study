class AddStudyEventIdToRooms < ActiveRecord::Migration[6.0]
  def up
    add_column :rooms, :study_event_id, :integer
  end

  def down
    remove_column :rooms, :study_event_id, :integer 
  end
end
