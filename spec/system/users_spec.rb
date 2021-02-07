require 'rails_helper'

RSpec.describe "Users", type: :system do
  describe "ゲストユーザーの場合" do
    before do
      visit root_path
      click_link "かんたんログイン"
    end

    it "かんたんログインできること" do
      expect(page).to have_content "ゲストユーザーとしてログインしました。"
    end

    it "アカウント編集ができないこと" do
      click_link "アカウント"
      click_button "更新"
      expect(page).to have_content "ゲストユーザーの変更・削除はできません"
    end

    it "アカウント削除ができないこと" do
      click_link "アカウント"
      click_button "アカウント削除"
      expect(page).to have_content "ゲストユーザーの変更・削除はできません"
    end
  end

  it "ユーザー登録できること" do
    visit root_path
    click_link "新規登録"

    expect {
      fill_in "メールアドレス", with: "foo@foo.com"
      fill_in "パスワード", with: "password"
      fill_in "パスワード確認", with: "password"
      click_button "アカウント登録"

      expect(page).to have_content "プロフィールを入力してください"
    }.to change(User, :count).by(1)  
  end

  describe "ユーザー編集・削除について" do
    let(:user) { FactoryBot.create(:user) }
    let!(:profile) { FactoryBot.create(:profile, user: user) }

    context "ユーザー情報の編集に成功した場合" do
      it "メールアドレスの変更ができること" do
        sign_in_as(user)
        visit root_path
        click_link "アカウント"

        fill_in "メールアドレス", with: "newfoo@foo.com"
        fill_in "現在のパスワード", with: user.password
        click_button "更新"
  
        expect(page).to have_content "アカウント情報を変更しました。"
        expect(user.reload.email).to eq "newfoo@foo.com"
      end 

      it "パスワードの変更ができること" do
        sign_in_as(user)
        visit root_path
        click_link "アカウント"

        fill_in "パスワード", with: "new_password"
        fill_in "パスワード確認", with: "new_password"
        fill_in "現在のパスワード", with: user.password
        click_button "更新"

        expect(page).to have_content "アカウント情報を変更しました。"
      end
    end

    context "現在のパスワードが入力されていない場合" do
      it "ユーザーの編集に失敗すること" do
        sign_in_as(user)
        visit root_path
        click_link "アカウント"

        fill_in "メールアドレス", with: "newfoo@foo.com"
        click_button "更新"
  
        expect(page).to have_content "現在のパスワードを入力してください"
      end
    end

    it "自身のアカウントを削除できること" do
      sign_in_as(user)
      visit root_path
      click_link "アカウント"

      expect {
        click_button "アカウント削除"

        expect(page).to have_content "アカウントを削除しました。またのご利用をお待ちしております。"
      }.to change(User, :count).by(-1)     
    end

    context "管理ユーザーの場合" do
      let(:admin_user) { FactoryBot.create(:user, :admin) }
      let!(:admin_profile) { FactoryBot.create(:profile, user: admin_user) }
  
      it "他のユーザーを削除できること" do
        sign_in_as(admin_user)
        visit root_path
        visit profile_path(profile)
  
        expect {
          click_link "ユーザーを削除"
  
          expect(page).to have_content("#{user.profile.username}を削除しました。")
        }.to change(User, :count).by(-1)
      end    
    end  
  end
end