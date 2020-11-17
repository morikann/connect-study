class AddColumnToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :profile, :text
    add_column :users, :aim, :text
  end
end
