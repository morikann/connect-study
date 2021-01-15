require 'rails_helper'

RSpec.describe TagRelationship, type: :model do
  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with profile" do
      let(:target) { :profile }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Profile' }
    end

    context "with tag" do
      let(:target) { :tag }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'Tag' }
    end
  end
end