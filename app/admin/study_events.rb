ActiveAdmin.register StudyEvent do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :description, :display_range, :begin_time, :finish_time, :date, :name, :user_id, :image
  #
  # or
  #
  # permit_params do
  #   permitted = [:description, :display_range, :begin_time, :finish_time, :date, :name, :user_id, :image]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end
  
end
