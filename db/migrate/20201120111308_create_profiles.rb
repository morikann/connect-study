class CreateProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :profiles do |t|
      t.references :user, foreign_key: true
      t.string :avatar
      t.date :birth_date, null: false
      t.string :purpose, null: false, limit: 50
      t.text :self_introduction, limit: 500
      t.string :username, null: false, limit: 30
      t.string :prefecture_id, null: false

      t.timestamps
    end
  end
end
