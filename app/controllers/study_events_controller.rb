class StudyEventsController < ApplicationController
  def index
  end

  def new 
    @study_event = StudyEvent.new
  end

  def edit 
  end

  def create
    @study_event = StudyEvent.new(study_event_params)
    if @study_event.save
      redirect_to new_path
    else
      render 'new'
    end
  end

  def update
  end

  def show
  end

  def destroy
  end

  private

  def study_event_params
    params.require('study_event').permit(:name, :description, :date, :display_range, :begin_time, :finish_time) 
  end
end
