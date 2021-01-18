require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "#create" do
    let(:user_params) { FactoryBot.attributes_for(:user) }
    context "有効な属性の場合" do
      it "ユーザーを作成できること" do
        expect {
          post user_registration_path, params: { user: user_params }
        }.to change(User, :count).by(1)
      end
    end

    context "無効な属性の場合" do
      it "ユーザーを作成できないこと" do
        user_params[:email] = nil
        expect {
          post user_registration_path, params: { user: user_params }
        }.to_not change(User, :count)
      end
    end
  end

  describe "#destroy" do
    let(:user) { FactoryBot.create(:user) }
    let!(:profile) { FactoryBot.create(:profile, user: user) }
    let(:other_user) { FactoryBot.create(:user) }

    it "自身のアカウントを削除できること" do
      sign_in user
      expect {
        delete user_registration_path(id: user.id)
      }.to change(User, :count).by(-1)
    end

    it "他者のアカウントは削除できないこと" do
      sign_in user
      expect {
        delete user_registration_path(id: other_user.id)
      }.to_not change(User, :count)
    end
  end

  describe "#edit" do
    let(:user) { FactoryBot.create(:user) }
    let(:other_user) { FactoryBot.create(:user) }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        get edit_user_registration_path(id: user.id)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      let!(:profile) { FactoryBot.create(:profile, user: user) }
      let!(:other_user_profile) { FactoryBot.create(:profile, user: other_user) }

      it "リクエストが成功すること" do
        sign_in user
        get edit_user_registration_path(id: user.id)
        expect(response).to have_http_status "200"
      end
    end
  end

  describe "#update" do
    let(:user) { FactoryBot.create(:user) }
    let(:user_params) { FactoryBot.attributes_for(:user, email: "new_email@example.com", current_password: user.password) }

    context "未ログインの場合" do
      it "ログインページへリダイレクトすること" do
        patch user_registration_path(user: user_params)
        expect(response).to redirect_to new_user_session_path
      end
    end

    context "ログインしている場合" do
      let!(:profile) { FactoryBot.create(:profile, user: user) }
      it "更新が成功すること" do
        sign_in user
        patch user_registration_path, params: { user: user_params }
        expect(user.reload.email).to eq "new_email@example.com"
      end
    end
  end
end
