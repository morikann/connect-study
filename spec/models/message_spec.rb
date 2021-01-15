require 'rails_helper'

RSpec.describe Message, type: :model do

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

    context "with room" do
      let(:target) { :room }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Room' }
    end
  end

  let(:user) { FactoryBot.create(:user) }
  let(:message) { FactoryBot.build(:message, user: user) }

  # メッセージがあれば有効な状態であること
  it "is valid with message" do
    expect(message).to be_valid
  end

  # メッセージがなければ無効な状態であること
  it "is invalid without message" do
    message.message = nil
    expect(message).to be_invalid
  end
end
