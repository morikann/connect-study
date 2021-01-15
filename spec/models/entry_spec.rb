require 'rails_helper'

RSpec.describe Entry, type: :model do

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
  let(:room) { Room.create }
  let(:params) { { user_id: user.id, room_id: room.id } }

  # user_idとroom_idがあれば有効な状態であること
  it "is valid with user_id and room_id" do
    entry = Entry.create(params)
    expect(entry).to be_valid
  end

  # user_idに対して重複したroom_idなら無効な状態であること
  it "is invalid with duplicate room_id for user_id" do
    Entry.create(params)
    duplicate_entry = Entry.new(params)
    duplicate_entry.valid?
    expect(duplicate_entry.errors[:room_id]).to include("はすでに存在します")
  end
end
