require 'rails_helper'

RSpec.describe "Bookmarks", type: :system, js: true do
  let(:user) { FactoryBot.create(:user) }
  let!(:profile) { FactoryBot.create(:profile, user: user) }
  let!(:study_event) { FactoryBot.create(:study_event, user: user) }
  let!(:location) { FactoryBot.create(:location, study_event: study_event) }
  
  before do
    sign_in_as(user)
    visit root_path

    # 勉強会一覧ページへ
    click_link '勉強会一覧'
    expect(page).to have_content '勉強会一覧'

    # 勉強会詳細ページへ
    find('.study-event-card').click
    expect(page).to have_content '勉強会詳細'
  end

  it "気になる勉強会に登録できること" do
    find('#bookmark').click
    expect(page).to have_selector '#delete-bookmark'
    expect(user.bookmarks.count).to eq(1)
  end

  it "気になる勉強会から削除できること" do
    find('#bookmark').click
    expect(page).to have_selector '#delete-bookmark'
    expect(user.bookmarks.count).to eq(1)

    find('#delete-bookmark').click 
    expect(page).to have_selector '#bookmark'
    expect(user.bookmarks.count).to eq(0)
  end
end