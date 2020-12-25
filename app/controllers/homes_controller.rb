class HomesController < ApplicationController
  skip_before_action :authenticate_user! 

  def index 
    @study_events = StudyEvent.joins(:event_users).where(event_users: {user_id: current_user.id})
  end
end