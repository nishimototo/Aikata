require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }

  describe 'showアクションのテスト' do
    it '正常なレスポンスを返すか' do
      get :show, params: { id: user.id }
      expect(response).to be_successful
    end
    it '200のレスポンスを返すか' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status '200'
    end
  end

  describe 'editアクションのテスト' do
    context 'ログイン済の場合' do
      it '正常なレスポンスを返すか' do
        sign_in user
        get :edit, params: { id: user.id }
        expect(response).to be_successful
      end
      it '200レスポンスが返ってきているか' do
        sign_in user
        get :edit, params: { id: user.id }
        expect(response).to have_http_status '200'
      end
    end

    context '他のログイン済ユーザーの場合' do
      it '正常なレスポンスを返さないか' do
        sign_in another_user
        get :edit, params: { id: user.id }
        expect(response).not_to be_successful
      end
      it '他のログイン済ユーザーがプロフィールを編集しようとするとユーザー詳細ページにリダイレクト' do
        sign_in another_user
        get :edit, params: { id: user.id }
        expect(response).to redirect_to "/users/#{user.id}"
      end
    end

    context 'ログインしていない場合' do
      it '302レスポンスが返ってきているか' do
        get :edit, params: { id: user.id }
        expect(response).to have_http_status '302'
      end
      it 'ユーザー詳細画面にリダイレクトされているか' do
        get :edit, params: { id: user.id }
        expect(response).to redirect_to "/users/#{user.id}"
      end
    end
  end

  describe 'updateアクションのテスト' do
    context 'ログイン済の場合' do
      it '正常にプロフィールを更新できるか' do
        sign_in user
        patch :update, params: { id: user.id, user: { name: '山田' } }
        expect(user.reload.name).to eq '山田'
      end
      it 'プロフィールを更新した後、ユーザー詳細ページにリダイレクトする' do
        sign_in user
        patch :update, params: { id: user.id, user: { name: '山田' } }
        expect(response).to redirect_to "/users/#{user.id}"
      end
      it '不正な属性を含むプロフィールは更新できなくなっているか' do
        sign_in user
        user_params = { name: nil }
        user = User.create(name: "山田", email: "yamada@gmail.com", password: "yamada")
        patch :update, params: { id: user.id, user: user_params }
        user.reload
        expect(user.reload.name). to eq "山田"
      end
      it '不正な属性を含むプロフィールを更新しようとすると再度編集ページへリダイレクトされるか' do
        sign_in user
        user_params = { name: nil }
        user = User.create(name: "山田", email: "yamada@gmail.com", password: "yamada")
        patch :update, params: { id: user.id, user: user_params }
        user.reload
        expect(response).to redirect_to "/users/#{user.id}"
      end
    end

    context '他のログイン済ユーザーの場合' do
      it '正常なレスポンスが返ってきていないか' do
        sign_in another_user
        get :edit, params: { id: user.id }
        expect(response).not_to be_successful
      end
      it '他のログイン済ユーザーがプロフィールを編集しようとするとユーザー詳細ページへリダイレクトされているか' do
        sign_in another_user
        get :edit, params: { id: user.id }
        expect(response).to redirect_to "/users/#{user.id}"
      end
    end

    context 'ログインしていない場合' do
      it '302レスポンスを返すか' do
        user_params = {
          name: '山田 ',
          email: 'yamada@gmail.com',
          password: 'yamada',
        }
        patch :update, params: { id: user.id, user: user_params }
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされているか' do
        user_params = {
          name: '山田 ',
          email: 'yamada@gmail.com',
          password: 'yamada',
        }
        patch :update, params: { id: user.id, user: user_params }
        expect(response).to redirect_to "/users/#{user.id}"
      end
    end
  end
end
