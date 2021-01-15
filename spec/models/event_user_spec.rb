require 'rails_helper'

RSpec.describe EventUser, type: :model do
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

    context "with user" do
      let(:target) { :user }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end
  end
end