class AddUserIdToStudyEvents < ActiveRecord::Migration[6.0]
  def up
    execute 'DELETE FROM study_events;'
    add_reference :study_events, :user, null: false, index: true
  end

  def down
    remove_reference :study_events, :user, index: true
  end
end
