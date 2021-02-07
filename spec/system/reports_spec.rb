require 'rails_helper'

RSpec.describe "Reports", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let!(:profile) { FactoryBot.create(:profile, user: user) }
  let!(:other_user) { FactoryBot.create(:user) }
  let!(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

  before do
    sign_in_as(user)
    visit root_path
    visit profile_path(other_user_profile)
    # アイコンをクリック
    find('.dropdown-button').click
    # 「通報する」をクリック
    find('.modal-trigger').click
  end

  it "通報できること" do
    fill_in "textarea2", with: "迷惑行為をされる"
    click_button "通報する"
    expect(page).to have_content "#{other_user_profile.username}さんを通報しました"
  end

  describe "通報内容が入力されていない場合" do
    it "通報できないこと" do
      fill_in "textarea2", with: ""
      click_button "通報する"
      expect(page).to have_content "入力内容に誤りがあります"
    end
  end

  describe "通報内容が200文字を超えていた場合" do
    it "通報できないこと" do
      fill_in "textarea2", with: "a" * 201
      click_button "通報する"
      expect(page).to have_content "入力内容に誤りがあります"
    end
  end
  
end