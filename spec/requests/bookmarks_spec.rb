require 'rails_helper'

RSpec.describe "Bookmarks", type: :request do
  describe "#create" do
    # let!(:user) { FactoryBot.create(:user) }
    # let!(:profile) { FactoryBot.create(:profile, user: user) }
    # let!(:study_event) { FactoryBot.create(:study_event) }
    before do
      @user = FactoryBot.create(:user)
      @profile = FactoryBot.create(:profile, user: @user)
      @study_event = FactoryBot.create(:study_event, user: @user)
    end

    it "bookmarkレコードを登録できる" do
      sign_in @user
      expect {
        post bookmarks_path, params: { study_event_id: @study_event.id, user_id: @user.id }
      }.to change(@user.bookmarks, :count).by(1)
      
    end
  end
end
