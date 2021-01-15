require 'rails_helper'

RSpec.describe Room, type: :model do
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

    context "with entries" do
      let(:target) { :entries }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Entry' }
    end

    context "with users" do
      let(:target) { :users }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with messages" do
      let(:target) { :messages }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Message' }
    end
  end
end
