require 'rails_helper'

RSpec.describe Notification, type: :model do
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

    context "with visitor" do
      let(:target) { :visitor }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with visited" do
      let(:target) { :visited }

      it { expect(association.macro).to eq :belongs_to }
      it { expect(association.class_name).to eq 'User' }
    end
  end
end