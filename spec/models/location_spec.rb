require 'rails_helper'

RSpec.describe Location, type: :model do

  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with study_event" do
      let(:target) { :study_event }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'StudyEvent' }
    end
  end

  let(:location) { FactoryBot.create(:location) }

  # 場所名、住所、都道府県、緯度、経度があれば有効な状態であること
  it "is valid with name, address, prefecture_id, latitude, and longitude" do
    expect(location).to be_valid
  end

  # 場所名がなければ無効な状態であること
  it "is invalid without prefecure_id" do
    location.name = nil 
    location.valid?
    expect(location.errors[:name]).to include("を入力してください")
  end

  # 住所がなければ無効な状態であること
  it "is invalid without address" do
    location.address = nil
    location.valid?
    expect(location.errors[:address]).to include("を入力してください")
  end

  # 都道府県がなければ無効な状態であること
  it "is invalid without prefecure_id" do
    location.prefecture_id = nil 
    location.valid?
    expect(location.errors[:prefecture_id]).to include("を入力してください")
  end

  # 無効な住所で緯度経度が取得できない時
  context "when latitude and longitude are nil" do
    let(:invalid_location) { FactoryBot.build(:location, :invalid_address) }
    # エラーメッセージが表示されること
    it "is raise error message" do
      invalid_location.valid?
      expect(invalid_location.errors[:base]).to include("正しい住所を入力してください")
    end
  end
end
