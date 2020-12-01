class HomesController < ApplicationController
  skip_before_action :authenticate_user! 

  def index
    if params[:search].present?
      @users = User.includes(profile: :tags).search(params[:search]).page(params[:page])
    else
      @users = User.includes(profile: :tags).page(params[:page])
    end
    # @user_profile = current_user.profile if current_user.present?
  end
end