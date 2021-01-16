require 'rails_helper'

RSpec.describe Tag, type: :model do

  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with tag_relationships" do
      let(:target) { :tag_relationships }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'TagRelationship' }
    end

    context "with profiles" do
      let(:target) { :profiles }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Profile' }
    end

    context "with event_tags" do
      let(:target) { :event_tags }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'EventTag' }
    end

    context "with study_events" do
      let(:target) { :study_events }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'StudyEvent' }
    end
  end

  describe "of validation test" do
    let(:tag) { FactoryBot.build(:tag) }

    # タグ名があれば有効な状態であること
    it "is valid with a name" do
      expect(tag).to be_valid
    end

    # タグ名がなければ無効な状態であること
    it "is invalid without a name" do
      tag.name = nil
      tag.valid?
      expect(tag.errors[:name]).to include("を入力してください")
    end

    # 重複したタグ名は許可しないこと
    it "dose not allow duplicate tag names" do
      Tag.create(name: 'タグ名')
      tag.valid?
      expect(tag.errors[:name]).to include("はすでに存在します")
    end
  end
end
