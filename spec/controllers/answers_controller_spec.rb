require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let(:theme) { create(:theme) }
  let!(:answer) { create(:answer) }

  describe 'indexアクションのテスト' do
    it '正常なレスポンスを返すか' do
      get :index, params: {theme_id: theme.id}
      expect(response).to be_successful
    end
    it '200レスポンスが返ってきているか' do
      get :index, params: {theme_id: theme.id}
      expect(response).to have_http_status '200'
    end
  end

  describe 'showアクションのテスト' do
    it '正常なレスポンスを返すか' do
      get :show, params: {id: answer.id, theme_id: theme.id}
      expect(response).to be_successful
    end
    it '200レスポンスが返ってきているか' do
      get :show, params: {id: answer.id, theme_id: theme.id}
      expect(response).to have_http_status '200'
    end
  end

  describe 'newアクションのテスト' do
    context 'ログイン済の場合' do
      it '正常なレスポンスを返すか' do
        sign_in user
        get :new, params: { theme_id: theme.id }
        expect(response).to be_successful
      end
      it '200レスポンスを返すか' do
        sign_in user
        get :new, params: { theme_id: theme.id }
        expect(response).to have_http_status "200"
      end
    end
    context 'ログインしていない場合' do
      it '正常なレスポンスを返さないか' do
        get :new, params: { theme_id: theme.id }
        expect(response).not_to be_successful
      end
      it '302レスポンスを返すか' do
        get :new, params: { theme_id: theme.id }
        expect(response).to have_http_status "302"
      end
      it 'ログイン画面にリダイレクトされるか' do
        get :new, params: { theme_id: theme.id }
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end