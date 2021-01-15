require 'rails_helper'

RSpec.describe Bookmark, type: :model do

  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with user" do
      let(:target) { :user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with study_event" do
      let(:target) { :study_event }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'StudyEvent' }
    end
  end

  describe "of validation test" do
    let(:user) { FactoryBot.create(:user) }
    let(:study_event) { FactoryBot.create(:study_event) }
    let(:params) { {user_id: user.id, study_event_id: study_event.id} }

    # user_idとstudy_event_idがあれば有効な状態であること
    it "is valid with user_id and study_event_id" do
      bookmark = Bookmark.create(params)
      expect(bookmark).to be_valid
    end

    # study_event_idに対して重複したuser_idなら無効な状態であること
    it "is invalid with a duplicate user_id for study_event_id" do
      Bookmark.create(params)
      bookmark = Bookmark.new(params)
      bookmark.valid?
      expect(bookmark.errors[:user_id]).to include("はすでに存在します")
    end
  end
end
