class AddPrefectureIdColumnToLocations < ActiveRecord::Migration[6.0]
  def up 
    add_column :locations, :prefecture_id, :string 
  end

  def down 
    remove_column :locations, :prefecture_id, :string 
  end
end
