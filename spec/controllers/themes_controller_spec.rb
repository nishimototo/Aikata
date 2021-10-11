require 'rails_helper'

RSpec.describe ThemesController, type: :controller do
  let(:user) { create(:user) }
  let!(:theme) { create(:theme) }

  describe 'indexアクションのテスト' do
    it '正常なレスポンスを返すか' do
      get :index
      expect(response).to be_successful
    end
    it '200レスポンスを返すか' do
      get :index
      expect(response).to have_http_status '200'
    end
  end

  describe 'newアクションのテスト' do
    context 'ログイン済の場合' do
      it '正常なレスポンスを返すか' do
        sign_in user
        get :new
        expect(response).to be_successful
      end
      it '200レスポンスを返すか' do
        sign_in user
        get :new
        expect(response).to have_http_status '200'
      end
    end

    context 'ログインしていない場合' do
      it '正常なレスポンスを返さないか' do
        get :new
        expect(response).not_to be_successful
      end
      it '302レスポンスを返すか' do
        get :new
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされるか' do
        get :new
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'createアクションのテスト' do
    context 'ログイン済の場合' do
      it '正常にお題を投稿できる' do
        sign_in user
        expect do
          post :create, params: {
            theme: {
              content: 'お題を投稿します',
              user_id: 1,
            },
          }
        end.to change(user.themes, :count).by(1)
      end
      it 'お題の投稿後にお題一覧のページにリダイレクトされるか' do
        sign_in user
        post :create, params: {
          theme: {
            content: 'お題を投稿します',
            user_id: 1,
          },
        }
        expect(response).to redirect_to '/themes'
      end
      it '不正な属性を含むお題は投稿できなくなっているか' do
        sign_in user
        expect do
          post :create, params: {
            theme: {
              content: nil,
              user_id: 1,
            },
          }
        end.not_to change(user.themes, :count)
      end
      it '不正な属性を含むお題を投稿しようとすると、お題投稿画面にリダイレクトされるか' do
        sign_in user
        post :create, params: {
          theme: {
            content: nil,
            user_id: 1,
          },
        }
        expect(response).to render_template :new
      end
    end

    context 'ログインしていない場合' do
      it '302のレスポンスが返ってきているか' do
        get :create
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされるか' do
        get :create
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end
