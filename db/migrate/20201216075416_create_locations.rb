class CreateLocations < ActiveRecord::Migration[6.0]
  def change
    create_table :locations do |t|
      t.string :name, null: false
      t.string :adress
      t.float :latitude
      t.float :longitude
      t.string :image

      t.timestamps
    end
  end
end
