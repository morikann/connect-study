require 'rails_helper'

RSpec.describe Profile, type: :model do

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

    context "with tag_relationships" do
      let(:target) { :tag_relationships }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'TagRelationship' }
    end

    context "with tags" do
      let(:target) { :tags }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Tag' }
    end
  end

  let(:profile) { FactoryBot.build(:profile) }
  # ユーザー名、目標、タグ、生年月日、都道府県があれば有効な状態であること
  it "is valid with username, purpose, tag, birth_date" do
    expect(profile).to be_valid
  end

  # ユーザー名がなければ無効な状態であること
  it "is invalid when username is nil" do
    profile.username = nil
    profile.valid?
    expect(profile.errors[:username]).to include("を入力してください")
  end

  # 目標がなければ無効な状態であること
  it "is invalid when purpose is nil" do
    profile.purpose = nil
    profile.valid?
    expect(profile.errors[:purpose]).to include("を入力してください")
  end

  # タグがなければ無効な状態であること
  it "is invalid when purpose is nil" do
    profile.tag = nil
    profile.valid?
    expect(profile.errors[:tag]).to include("を入力してください")
  end

  # 生年月日がなければ無効な状態であること
  it "is invalid when purpose is nil" do
    profile.birth_date = nil
    profile.valid?
    expect(profile.errors[:birth_date]).to include("を入力してください")
  end

  # 都道府県がなければ無効な状態であること
  it "is invalid when purpose is nil" do
    profile.prefecture_id = nil
    profile.valid?
    expect(profile.errors[:prefecture_id]).to include("を入力してください")
  end

  # ユーザー名が50文字より多い場合は無効な状態であること
  it "is invalid when username is longer than 50 characters" do
    profile.username = "a" * 51
    profile.valid?
    expect(profile.errors[:username]).to include("は50文字以内で入力してください")
  end

  # ユーザー名が50文字以内の場合は有効な状態であること
  it "is valid when username is within 50 characters" do
    profile.username = "a" * 49
    expect(profile).to be_valid
  end

  # 目標が30文字より多い場合は無効な状態であること
  it "is invalid when purpose is longer than 30 characters" do
    profile.purpose = "a" * 31
    profile.valid?
    expect(profile.errors[:purpose]).to include("は30文字以内で入力してください")
  end

  # 目標が30文字以内の場合は有効な状態であること
  it "is valid when purpose is within 30 characters" do
    profile.purpose = "a" * 29
    profile.valid?
    expect(profile).to be_valid
  end
end
