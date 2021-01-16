require 'rails_helper'

RSpec.describe Report, type: :model do

  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with reported_user" do
      let(:target) { :reported_user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with reporter_user" do
      let(:target) { :reporter_user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end
  end

  describe "of validation test" do
    before do
      @user1 = FactoryBot.create(:user)
      @user2 = FactoryBot.create(:user)
      @report = FactoryBot.build(:report)
    end
  
    # 通報者、通報された人、内容があれば有効な状態であること
    it "is valid with description" do
      @report.reported_user_id = @user1.id
      @report.reporter_user_id = @user2.id
      expect(@report).to be_valid
    end
  
    # 内容が200文字より多い場合
    context "when description is longer_than 200 characters" do
      # 無効な状態であること
      it "is invalid" do
        @report.description = "a" * 201
        @report.valid?
        expect(@report.errors[:description]).to include("は200文字以内で入力してください")
      end
    end
  
    # 内容が200文字以内の場合
    context "when description is within 200 characters" do
      # 有効な状態であること
      it "is valid" do
        @report.description = "a" * 199
        @report.reported_user_id = @user1.id
        @report.reporter_user_id = @user2.id
        expect(@report).to be_valid
      end
    end
  end
end
