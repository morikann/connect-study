class BookmarksController < ApplicationController
  def create
    @study_event = StudyEvent.find(params[:study_event])
    current_user.bookmark(@study_event)
  end

  def destroy
    @study_event = Bookmark.find(params[:id]).study_event
    current_user.delete_bookmark(@study_event)
  end
end
