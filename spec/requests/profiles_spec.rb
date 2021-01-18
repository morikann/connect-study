require 'rails_helper'

RSpec.describe "Profiles", type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe "#create" do
    let(:profile_params) { FactoryBot.attributes_for(:profile) }

    context "認証済みのユーザーとして" do
      context "有効な属性の場合" do
        it "プロフィールを作成できること" do
          sign_in user
          expect {
            post profiles_path, params: { profile: profile_params }
          }.to change(Profile, :count).by(1)
        end
      end

      context "無効な属性の場合" do
        let(:invalid_profile_params) { FactoryBot.attributes_for(:profile, :invalid) }
        it "プロフィールを作成できないこと" do
          sign_in user
          expect {
            post profiles_path, params: { profile: invalid_profile_params }
          }.to_not change(Profile, :count)
        end
      end
    end

    context "認証されていないユーザーとして" do
      it "302レスポンスを返すこと" do
        post profiles_path, params: { profile: profile_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        post profiles_path, params: { profile: profile_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end

  describe "#edit" do
    let!(:profile) { FactoryBot.create(:profile, user: user) }

    context "認可されたユーザーとして" do
      it "正常にレスポンスを返すこと" do
        sign_in user
        get edit_profile_path(profile)
        expect(response).to be_successful
      end

      it "200レスポンスを返すこと" do
        sign_in user
        get edit_profile_path(profile)
        expect(response).to have_http_status "200"
      end
    end

    context "認可されていないユーザーとして" do
      let(:other_user) { FactoryBot.create(:user) }
      let(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

      it "302レスポンスを返すこと" do
        sign_in user
        get edit_profile_path(other_user_profile)
        expect(response).to have_http_status "302"
      end

      it "トップページにリダイレクトすること" do
        sign_in user
        get edit_profile_path(other_user_profile)
        expect(response).to redirect_to root_path
      end
    end
  end

  describe "#update" do
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let(:profile_params) { FactoryBot.attributes_for(:profile, username: "new name") }

    context "認可されたユーザーとして" do
      it "プロフィールを更新できること" do
        sign_in user
        patch profile_path(profile), params: { profile: profile_params }
        expect(profile.reload.username).to eq "new name"
      end
    end

    context "認可されていないユーザーとして" do
      let(:other_user) { FactoryBot.create(:user) }
      let(:other_user_profile) { FactoryBot.create(:profile, user: other_user, username: "old name") }

      it "プロフィールを更新できないこと" do
        sign_in user
        patch profile_path(other_user_profile), params: { profile: profile_params }
        expect(other_user_profile.reload.username).to eq "old name"
      end

      it "ダッシュボードへリダイレクトすること" do
        sign_in user
        patch profile_path(other_user_profile), params: { profile: profile_params }
        expect(response).to redirect_to root_path
      end
    end

    context "認証されていないユーザーとして" do
      it "302レスポンスを返すこと" do
        patch profile_path(profile), params: { profile: profile_params }
        expect(response).to have_http_status "302"
      end

      it "サインイン画面にリダイレクトすること" do
        patch profile_path(profile), params: { profile: profile_params }
        expect(response).to redirect_to "/users/sign_in"
      end
    end
  end
end
