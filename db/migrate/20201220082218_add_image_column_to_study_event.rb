class AddImageColumnToStudyEvent < ActiveRecord::Migration[6.0]
  def up
    add_column :study_events, :image, :string
  end

  def down 
    remove_column :study_events, :image, :string
  end
end
