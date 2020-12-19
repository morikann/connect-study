class RenameAdressColumnToAddress < ActiveRecord::Migration[6.0]
  def change
    rename_column :locations, :adress, :address
  end
end
