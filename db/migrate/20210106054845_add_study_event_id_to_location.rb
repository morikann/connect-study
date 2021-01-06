class AddStudyEventIdToLocation < ActiveRecord::Migration[6.0]
  def up
    add_reference :locations, :study_event, foreign_key: true
  end

  def down
    remove_reference :locations, :study_event, foreign_key: true
  end
end
