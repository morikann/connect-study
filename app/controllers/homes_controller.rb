class HomesController < ApplicationController
  skip_before_action :authenticate_user! 

  def index
    @users = User.page(params[:page])
    @user_profile = current_user.profile if current_user.present?
  end
end
