class CreateTagRelationships < ActiveRecord::Migration[6.0]
  def change
    create_table :tag_relationships do |t|
      t.references :profile, foreign_key: true
      t.references :tag, foreign_key: true

      t.timestamps
    end
    add_index :tag_relationships, [:profile_id, :tag_id], unique: true
  end
end
