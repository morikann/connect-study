require 'rails_helper'

RSpec.describe "Profiles", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let(:other_user) { FactoryBot.create(:user) }
  let(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

  it "ユーザーは新しいプロフィールを作成できること" do
    sign_in_as(user)
    visit new_profile_path

    expect {
      fill_in "ユーザー名", with: "ユーザー"
      select "2000", from: "profile[birth_date(1i)]"
      select "1月", from: "profile[birth_date(2i)]"
      select "1", from: "profile[birth_date(3i)]"
      select "北海道", from: "profile[prefecture_id]"
      fill_in "tag-field", with: "プログラミング"
      fill_in "目標", with: "目標"
      click_button "プロフィール登録"

      expect(page).to have_content "プロフィールの設定が完了しました"
      expect(page).to have_content "ホーム"
      expect(page).to have_content user.profile.purpose
    }.to change(Profile, :count).by(1)
  end

  describe "プロフィールの編集について" do
    let!(:profile) { FactoryBot.create(:profile, user: user) }

    before do
      sign_in_as(user)
      visit root_path
    end

    it "ユーザーは自身のプロフィールを編集できること" do
      click_link "マイページ"
      click_link "プロフィールを編集する"

      fill_in "profile[username]", with: "新規名前"
      fill_in "tag-field", with: "プログラミング"
      click_button "プロフィール更新"

      expect(page).to have_content "プロフィールの変更が完了しました"
      expect(page).to have_content "新規名前"
    end

    it "ユーザーは他者のプロフィールは編集できないこと" do
      visit edit_profile_path(other_user_profile)
      expect(page).to have_current_path(root_path)
    end
  end

  describe "詳細ページについて" do
    let!(:profile) { FactoryBot.create(:profile, user: user) }

    before do
      sign_in_as(user)
      visit root_path
    end

    context "自身の詳細ページの場合" do
      it "プロフィールの編集リンクがあること" do
        click_link "マイページ"

        expect(page).to have_content "プロフィールを編集する"
        click_link "プロフィールを編集する"
        expect(page).to have_current_path(edit_profile_path(profile))
      end
    end

    context "他者の詳細ページの場合" do
      it "通報できること" do
        visit profile_path(other_user_profile)
        expect(page).to have_content "通報する"
        expect(page).to have_content "通報内容を記入してください"
      end

      it "メッセージを送れること" do
        visit profile_path(other_user_profile)
        expect(page).to have_content "mail_outline"
      end
    end
  end
end
