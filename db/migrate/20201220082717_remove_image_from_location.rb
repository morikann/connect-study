class RemoveImageFromLocation < ActiveRecord::Migration[6.0]
  def up
    remove_column :locations, :image, :string
  end

  def down
    add_column :locations, :image, :string 
  end
end
