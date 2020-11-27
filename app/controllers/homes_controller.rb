class HomesController < ApplicationController
  skip_before_action :authenticate_user! 

  def index
    @users = User.all
    @user_profile = current_user.profile
  end
end
