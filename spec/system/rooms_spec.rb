require 'rails_helper'

RSpec.describe "Rooms", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let!(:profile) { FactoryBot.create(:profile, user: user) }
  let!(:other_user) { FactoryBot.create(:user) }
  let!(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

  before do
    sign_in_as(user)
    visit root_path
  end

  describe "メッセージルームがない場合" do
    it "新しいメッセージルームが作れる" do
      # プロフィールページへ移動
      visit profile_path(other_user_profile)    
      expect {
        # DMアイコンをクリック
        find('.profile-dm').click
      }.to change(Room, :count).by(1)
    end
  end

  describe "メッセージルームが存在している場合" do
    let!(:room) { FactoryBot.create(:room) }
    let!(:entry) { FactoryBot.create(:entry, user: user, room: room) }
    let!(:other_user_entry) { FactoryBot.create(:entry, user: other_user, room: room) }

    it "既存のメッセージルームに移動する" do
      # プロフィールページへ移動
      visit profile_path(other_user_profile)

      # DMアイコンをクリック
      find('.profile-dm').click
      expect(page).to have_current_path room_path(room)
    end
  end
end