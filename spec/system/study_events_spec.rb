require 'rails_helper'

RSpec.describe "StudyEvents", type: :system do
  let(:user) { FactoryBot.create(:user) }
  let!(:profile) { FactoryBot.create(:profile, user: user) }
  let(:other_user) { FactoryBot.create(:user) }
  let!(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

  before do
    sign_in_as(other_user)
    visit root_path
  end

  describe "勉強会の公開範囲が全体の場合" do
    let(:study_event) { FactoryBot.create(:study_event, user: user) }
    let!(:location) { FactoryBot.create(:location, study_event: study_event) }

    it "勉強会が表示されること" do
      click_link '勉強会一覧'
      expect(page).to have_content study_event.name
    end
  end

  describe "勉強会の公開範囲がフォロワーのみの場合" do
    let(:study_event) { FactoryBot.create(:study_event, :private, user: user) }
    let!(:location) { FactoryBot.create(:location, study_event: study_event) }

    describe "勉強会の主催者をフォローしている場合" do
      it "勉強会が表示されること" do
        # 主催者をフォロー
        other_user.follow(user)
        click_link '勉強会一覧'
        expect(page).to have_content study_event.name
      end
    end
  
    describe "勉強会の主催者をフォローしていない場合" do
      it "勉強会が表示されないこと" do
        click_link '勉強会一覧'
        expect(page).to_not have_content study_event.name
      end
    end  
  end

  describe "勉強会に参加している場合", js: true do
    let!(:study_event) { FactoryBot.create(:study_event, user: user) }
    let!(:location) { FactoryBot.create(:location, study_event: study_event) }
    let!(:event_user) { FactoryBot.create(:event_user, user: other_user, study_event: study_event) }

    it "参加希望通知を送れないこと" do
      visit study_event_path(study_event)
      # 参加希望ボタンをクリック
      find('.btn-small').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content "すでに参加しています"
    end
  end

  describe "勉強会に参加していない場合", js: true do
    let!(:study_event) { FactoryBot.create(:study_event, user: user) }
    let!(:location) { FactoryBot.create(:location, study_event: study_event) }

    it "参加希望通知を送れること" do
      visit study_event_path(study_event)
      # 参加希望ボタンをクリック
      find('.btn-small').click
      page.driver.browser.switch_to.alert.accept
      expect(page).to have_content "参加希望の申請が完了しました"
    end
  end

  describe "勉強会を作成する場合" do
    before do
      click_link "勉強会一覧"

      # 「勉強会を作る」ボタンをクリック
      find('.btn-fixed').click
    end

    it "step2のページから前のページへ戻ることができること" do
      check 'private(フォロワーのみ)'
      fill_in "勉強会名", with: "プログラミング勉強会"
      fill_in "日にち", with: "2021/02/20"
      fill_in "開始時刻", with: "20:00"
      fill_in "終了時刻", with: "21:00"
      fill_in "tag-field", with: "プログラミング"
      fill_in "詳細", with: "勉強会です"
      click_button "次へ"
      expect(page).to have_current_path step2_path, ignore_query: true

      click_button "戻る"
      expect(page).to have_current_path step1_path, ignore_query: true
    end

    it "step3のページから前のページへ戻ることができること" do
      check 'private(フォロワーのみ)'
      fill_in "勉強会名", with: "プログラミング勉強会"
      fill_in "日にち", with: "2021/02/20"
      fill_in "開始時刻", with: "20:00"
      fill_in "終了時刻", with: "21:00"
      fill_in "tag-field", with: "プログラミング"
      fill_in "詳細", with: "勉強会です"
      click_button "次へ"
      expect(page).to have_current_path step2_path, ignore_query: true

      fill_in "開催場所", with: "スターバックス"
      select "東京", from: "location[prefecture_id]"
      fill_in "study-event-address", with: "日本、〒153-0042 東京都目黒区青葉台２丁目１９−２３"
      click_button "次へ"
      expect(page).to have_current_path step3_path, ignore_query: true

      click_button "戻る"
      expect(page).to have_current_path step2_path, ignore_query: true

      click_button "戻る"
      expect(page).to have_current_path step1_path, ignore_query: true
    end

    it "confirmページから前のページへ戻ることができること" do
      check 'private(フォロワーのみ)'
      fill_in "勉強会名", with: "プログラミング勉強会"
      fill_in "日にち", with: "2021/02/20"
      fill_in "開始時刻", with: "20:00"
      fill_in "終了時刻", with: "21:00"
      fill_in "tag-field", with: "プログラミング"
      fill_in "詳細", with: "勉強会です"
      click_button "次へ"
      expect(page).to have_current_path step2_path, ignore_query: true

      fill_in "開催場所", with: "スターバックス"
      select "東京", from: "location[prefecture_id]"
      fill_in "study-event-address", with: "日本、〒153-0042 東京都目黒区青葉台２丁目１９−２３"
      click_button "次へ"
      expect(page).to have_current_path step3_path, ignore_query: true

      click_button "次へ"
      expect(page).to have_current_path confirm_path, ignore_query: true

      click_button "戻る"
      expect(page).to have_current_path step3_path, ignore_query: true

      click_button "戻る"
      expect(page).to have_current_path step2_path, ignore_query: true

      click_button "戻る"
      expect(page).to have_current_path step1_path, ignore_query: true
    end

    it "一連の流れで勉強会を作成できること" do
      check 'private(フォロワーのみ)'
      fill_in "勉強会名", with: "プログラミング勉強会"
      fill_in "日にち", with: "2021/02/20"
      fill_in "開始時刻", with: "20:00"
      fill_in "終了時刻", with: "21:00"
      fill_in "tag-field", with: "プログラミング"
      fill_in "詳細", with: "勉強会です"
      click_button "次へ"
      expect(page).to have_current_path step2_path, ignore_query: true
  
      fill_in "開催場所", with: "スターバックス"
      select "東京", from: "location[prefecture_id]"
      fill_in "study-event-address", with: "日本、〒153-0042 東京都目黒区青葉台２丁目１９−２３"
      click_button "次へ"
      expect(page).to have_current_path step3_path, ignore_query: true
  
      click_button "次へ"
      expect(page).to have_current_path confirm_path, ignore_query: true
  
      click_button "make-study-event"
      expect(page).to have_content "勉強会「プログラミング勉強会」を作成しました"
    end
  end

  describe "勉強会の編集・削除について" do
    let!(:study_event) { FactoryBot.create(:study_event, user: other_user) }
    let!(:location) { FactoryBot.create(:location, study_event: study_event) }

    it "勉強会を編集できること" do
      click_link "マイページ"

      # 開催した勉強会を表示するタブをクリック
      find('#my-study-event').click
      expect(page).to have_content "プログラミング勉強会"

      # 勉強会の編集アイコンをクリック
      find('#edit-study-event').click  
      check 'private(フォロワーのみ)'
      fill_in "勉強会名", with: '英語の勉強会'
      fill_in "日にち", with: "2021/02/20"
      fill_in "開始時刻", with: "20:00"
      fill_in "終了時刻", with: "21:00"
      fill_in "tag-field", with: "プログラミング"
      fill_in "詳細", with: "勉強会です"
      click_button "更新"
      expect(page).to have_content "勉強会の更新が完了しました"

      # 開催した勉強会を表示するタブをクリック
      find('#my-study-event').click
      expect(page).to have_content "英語の勉強会"
    end

    it "勉強会を削除できること", js: true do
      click_link "マイページ"
      find('#my-study-event').click

      expect {
        # 勉強会の削除アイコンをクリック
        find('#delete-study-event').click

        # confirmダイアログを承認する
        page.driver.browser.switch_to.alert.accept

        expect(page).to have_content "勉強会を削除しました"
      }.to change(other_user.my_study_events, :count).by(-1)
      
    end
  end
end