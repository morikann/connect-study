class RelationshipsController < ApplicationController

  def create
    user = User.find(params[:follower_id])
    current_user.follow(user)
    redirect_to user.profile
  end

  def destroy 
    user = Relationship.find(params[:id]).follower
    current_user.unfollow(user)
    redirect_to user.profile
  end
  
end
