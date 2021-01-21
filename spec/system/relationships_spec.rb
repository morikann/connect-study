require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:profile) { FactoryBot.create(:profile, user: user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

  context "ユーザーが他者をフォローした場合" do
    before do
      sign_in_as(user)
      visit root_path

      visit profile_path(other_user_profile)
    end

    it "他者のフォロワーが増えること" do
      expect {
        click_button "フォローする"
      }.to change(other_user.followers, :count).by(1)
    end

    it "自身のフォローしているユーザー数が増えること" do
      expect {
        click_button "フォローする"
      }.to change(user.following, :count).by(1)
    end
  end

  context "ユーザーが他者のフォローを外した場合" do
    before do
      sign_in_as(user)
      visit root_path

      visit profile_path(other_user_profile)
      click_button "フォローする"
    end

    it "他者のフォロワーが減ること" do    
      expect {
        click_button "フォローを外す"
      }.to change(other_user.followers, :count).by(-1)
    end

    it "自身のフォローしているユーザー数が減ること" do
      expect {
        click_button "フォローを外す"
      }.to change(user.following, :count).by(-1)
    end
  end
end