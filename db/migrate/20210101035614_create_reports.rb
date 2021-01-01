class CreateReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reports do |t|
      t.text :description, null: false
      t.integer :reported_user_id, null: false
      t.integer :reporter_user_id, null: false

      t.timestamps
    end
  end
end
