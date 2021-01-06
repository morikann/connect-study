class RemoveLocationIdFromStudyEvents < ActiveRecord::Migration[6.0]
  def change
    remove_reference :study_events, :location, index: true, foreign_key: true
  end
end
