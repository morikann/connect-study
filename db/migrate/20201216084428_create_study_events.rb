class CreateStudyEvents < ActiveRecord::Migration[6.0]
  def change
    create_table :study_events do |t|
      t.text :description, null: false
      t.boolean :display_range, null: false
      t.time :begin_time, null: false
      t.time :finish_time, null: false
      t.date :date, null: false
      t.string :name, null: false
      t.references :location, foreign_key: true

      t.timestamps
    end
    add_index :study_events, :name
  end
end
