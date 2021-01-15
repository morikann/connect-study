require 'rails_helper'

RSpec.describe StudyEvent, type: :model do

  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with location" do
      let(:target) { :location }

      it { expect(association.macro).to eq :has_one }
      it { expect(association.class_name).to eq 'Location' }
    end

    context "with user" do
      let(:target) { :user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with event_users" do
      let(:target) { :event_users }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'EventUser' }
    end

    context "with users" do
      let(:target) { :users }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with event_tags" do
      let(:target) { :event_tags }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'EventTag' }
    end

    context "with tags" do
      let(:target) { :tags }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Tag' }
    end

    context "with bookmarks" do
      let(:target) { :bookmarks }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Bookmark' }
    end

    context "with bookmark_users" do
      let(:target) { :bookmark_users }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with notifications" do
      let(:target) { :notifications }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Notification' }
    end

    context "with room" do
      let(:target) { :room }

      it { expect(association.macro).to eq :has_one }
      it { expect(association.class_name).to eq 'Room' }
    end
  end

  let(:study_event) { FactoryBot.build(:study_event) }
  # 勉強会名、説明、開始時間、終了時間、日付、タグ、関連されたユーザーがあれば有効な状態であること
  it "is valid with name, description, begin_time, finish_time, date, tag, and user_id" do
    expect(study_event).to be_valid
  end

  # 勉強会名がなければ無効な状態であること
  it "is invalid without a name" do
    study_event.name = nil
    study_event.valid?
    expect(study_event.errors[:name]).to include("を入力してください")
  end

  # 説明がなければ無効な状態であること
  it "is invalid without a name" do
    study_event.description = nil
    study_event.valid?
    expect(study_event.errors[:description]).to include("を入力してください")
  end

  # 開始時刻がなければ無効な状態であること
  it "is invalid without a name" do
    study_event.begin_time = nil
    study_event.valid?
    expect(study_event.errors[:begin_time]).to include("を入力してください")
  end

  # 終了時刻がなければ無効な状態であること
  it "is invalid without a name" do
    study_event.finish_time = nil
    study_event.valid?
    expect(study_event.errors[:finish_time]).to include("を入力してください")
  end

  # 日付がなければ無効な状態であること
  it "is invalid without a name" do
    study_event.date = nil
    study_event.valid?
    expect(study_event.errors[:date]).to include("を入力してください")
  end

  # タグがなければ無効な状態であること
  it "is invalid without a name" do
    study_event.tag = nil
    study_event.valid?
    expect(study_event.errors[:tag]).to include("を入力してください")
  end

  # 勉強会名が30文字より多い場合
  context "when description is longer_than 30 characters" do
    # 無効な状態であること
    it "is invalid" do
      @study_event = FactoryBot.build(:study_event, name: "a" * 31)
      @study_event.valid?
      expect(@study_event.errors[:name]).to include("は30文字以内で入力してください")
    end
  end
end
