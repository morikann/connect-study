class AddAddressToUsers < ActiveRecord::Migration[6.0]
  def up
    add_column :users, :address, :string
  end

  def down 
    add_column :users, :address, :string 
  end
end
