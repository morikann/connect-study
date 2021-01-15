require 'rails_helper'

RSpec.describe Relationship, type: :model do
  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with following" do
      let(:target) { :following }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with follower" do
      let(:target) { :follower }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end
  end
end