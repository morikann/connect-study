require 'rails_helper'

RSpec.describe User, type: :model do
  # 関連付けのテスト
  describe "of association" do
    let(:association) do
      described_class.reflect_on_association(target)
    end

    context "with profile" do
      let(:target) { :profile }

      it { expect(association.macro).to eq :has_one }
      it { expect(association.class_name).to eq 'Profile' }
    end

    context "with acitve_relationships" do
      let(:target) { :active_relationships }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Relationship' }
    end

    context "with following" do
      let(:target) { :following }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with passive_relationships" do
      let(:target) { :passive_relationships }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Relationship' }
    end

    context "with followers" do
      let(:target) { :followers }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'User' }
    end

    context "with active_notifications" do
      let(:target) { :active_notifications }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Notification' }
    end

    context "with passive_notifications" do
      let(:target) { :passive_notifications }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Notification' }
    end

    context "with entries" do
      let(:target) { :entries }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Entry' }
    end

    context "with rooms" do
      let(:target) { :rooms }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Room' }
    end

    context "with messages" do
      let(:target) { :messages }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Message' }
    end

    context "with event_users" do
      let(:target) { :event_users }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'EventUser' }
    end

    context "with study_events" do
      let(:target) { :study_events }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'StudyEvent' }
    end

    context "with my_study_events" do
      let(:target) { :my_study_events }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'StudyEvent' }
    end

    context "with bookmarks" do
      let(:target) { :bookmarks }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Bookmark' }
    end

    context "with bookmark_events" do
      let(:target) { :bookmark_events }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'StudyEvent' }
    end

    context "with active_reports" do
      let(:target) { :active_reports }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Report' }
    end

    context "with passive_reports" do
      let(:target) { :passive_reports }

      it { expect(association.macro).to eq :has_many }
      it { expect(association.class_name).to eq 'Report' }
    end
  end

  let(:user) { FactoryBot.build(:user) }

  # メール、パスワードがあれば有効な状態であること
  it "is valid with email, and password" do
    expect(user).to be_valid
  end

  # メールアドレスがなければ無効な状態であること
  it "is invalid without an email address" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("を入力してください")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: 'example@example.com')
    user.email = 'example@example.com'
    user.valid?
    expect(user.errors[:email]).to include("はすでに存在します")
  end

  # パスワードがなければ無効な状態であること
  it "is invalid without a password" do
    user.password = nil
    user.valid?
    expect(user.errors[:password]).to include("を入力してください")
  end
  
  # 検索文字列に一致するタグを登録しているユーザーを検索する
  describe "search user for a term" do
    before do
      @user = FactoryBot.create(:user)
      profile = FactoryBot.create(:profile, user: @user)
      @other_user = FactoryBot.create(:user)
      other_user_profile = FactoryBot.create(:profile, user: @other_user)
      tag = FactoryBot.create(:tag)
      tag_relation = FactoryBot.create(:tag_relationship, profile: profile, tag: tag)
      other_tag_relation = FactoryBot.create(:tag_relationship, profile: other_user_profile, tag: tag)
    end

    # 一致するデータが見つかるとき
    context "when a match is found" do
      # 検索文字列に一致するタグを登録しているユーザーを返すこと
      it "returns users that match the search term" do
        expect(User.search({ tag: 'タグ名', prefecture_id: nil })).to include(@user, @other_user)
      end
    end
    
    # 一致するデータが一件も見つからない時
    context "when no match is found" do
      # 空のコレクションを返すこと
      it "returns an empty collection" do
        expect(User.search({ tag: 'rails', prefecure_id: nil })).to be_empty
      end
    end
  end

  # 検索文字に一致する都道府県を登録しているユーザーを検索する
  describe "seach user for prefecture" do
    before do
      @user = FactoryBot.create(:user)
      @other_user = FactoryBot.create(:user)
      profile = FactoryBot.create(:profile, user: @user)
      other_user_profile = FactoryBot.create(:profile, user: @other_user)
    end

    # 一致するデータが見つかる時
    context "when a match is found" do
      # 検索文字に一致する都道府県を登録しているユーザーを返すこと
      it "returns users that match the search term" do
        expect(User.search({ tag: nil, prefecture_id: 10 })).to include(@user, @other_user)
      end
    end

    # 一致するデータが見つからない時
    context "when no match is found" do
      # 空のコレクションを返すこと
      it "returns an empty collection" do
        expect(User.search({ tag: nil, prefecture_id: 1 })).to be_empty
      end
    end
  end
end
