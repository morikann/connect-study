require 'rails_helper'

RSpec.describe "Messages", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let!(:profile) { FactoryBot.create(:profile, user: user) }
  let!(:other_user) { FactoryBot.create(:user) }
  let!(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

  describe "メッセージを送信した場合" do
    before do
      sign_in_as(user)
      visit root_path
      click_link "ユーザーを探す"
  
      # ユーザーリンクをクリック
      find('.user-list-link').click
      click_button "メッセージ"
  
      # メッセージを入力 & 送信
      fill_in "message-textarea", with: "初めまして"
      find('#message-btn').click
    end

    it "送信した側でメッセージが表示されること" do   
      expect(page).to have_content "初めまして"
    end

    it "受信側でメッセージが表示されること" do
      # ログインユーザーを入れ替えるため、ログアウトする
      click_link 'ログアウト'
    
      # JSのconfirmダイアログを押す
      page.driver.browser.switch_to.alert.accept
  
      # 受信側でログイン
      click_link "ログイン"
      fill_in "メールアドレス", with: other_user.email
      fill_in "パスワード", with: other_user.password
      click_button "ログイン"
      visit root_path 
      click_link 'メッセージ'

      # メッセージルームへ移動
      find('.collection-item').click
      expect(page).to have_content '初めまして'
    end
  end
end