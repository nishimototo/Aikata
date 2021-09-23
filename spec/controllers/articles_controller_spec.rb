require 'rails_helper'

RSpec.describe ArticlesController, type: :controller do
  let(:user) { create(:user) }
  let(:another_user) { create(:another_user) }
  let!(:article) { create(:article) }

  describe 'indexアクションのテスト' do
    it '正常なレスポンスを返すか' do
      get :index
      expect(response).to be_successful
    end
    it '200レスポンスが返ってきているか' do
      get :index
      expect(response).to have_http_status '200'
    end
  end

  describe 'showアクションのテスト' do
    it '正常なレスポンスを返すか' do
      get :show, params: {id: article.id}
      expect(response).to be_successful
    end
    it '200レスポンスが返ってきているか' do
      get :show, params: {id: article.id}
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
      it '200レスポンスが返ってきているか' do
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
      it '302レスポンスが返ってきているか' do
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
      it '正常に記事を投稿できるか' do
        sign_in user
        expect {
          post :create, params: {
            article: {
              title: '相方募集',
              content: '相方を探しています',
              area: '中部エリア',
              category: '相方募集',
              user_id: 1
            }
          }
        }.to change(user.articles, :count).by(1)
      end
      it '記事の投稿後に記事一覧ページにリダイレクトされるか' do
        sign_in user
        post :create, params: {
          article: {
            title: '相方募集',
            content: '相方を探しています',
            area: '中部エリア',
            category: '相方募集',
            user_id: 1
          }
        }
        expect(response).to redirect_to '/articles'
      end
      it '不正な属性を含む記事は投稿できなくなっているか' do
        sign_in user
        expect {
          post :create, params: {
            article: {
              title: nil,
              content: '相方を探しています',
              area: '中部エリア',
              category: '相方募集',
              user_id: 1
            }
          }
        }.not_to change(user.articles, :count)
      end
      it '不正な属性の記事を投稿しようとすると、再度記事作成ページへリダイレクトされるか' do
        sign_in user
        post :create, params: {
          article: {
            title: nil,
            content: '相方を探しています',
            area: '中部エリア',
            category: '相方募集',
            user_id: 1
          }
        }
        expect(response).to render_template :new  #redirect_toで書けるならそっちで
      end
    end

    context 'ログインしていない場合' do
      it '302のレスポンスが返ってきているか' do
        get :create
        expect(response). to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされているか' do
        get :create
        expect(response). to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'editアクションのテスト' do
    context 'ログイン済の場合' do
      it '正常なレスポンスを返すか' do
        sign_in user
        @article = Article.create(user_id: user.id, title: '相方募集', content: '相方を探しています', area: '関東募集', category: '相方募集')
        get :edit, params: {id: @article.id}
        expect(response).to be_successful
      end
      it '200レスポンスが返ってきているか' do
        sign_in user
        @article = Article.create(user_id: user.id, title: '相方募集', content: '相方を探しています', area: '関東募集', category: '相方募集')
        get :edit, params: {id: @article.id}
        expect(response).to have_http_status '200'
      end
    end
    context '他のログイン済ユーザーの場合' do
      it '正常なレスポンスを返さないか' do
        sign_in another_user
        get :edit, params: {id: article.id}
        expect(response).not_to be_successful
      end
      it '他のログイン済ユーザーが記事を編集しようとすると記事一覧ページにリダイレクト' do
        sign_in another_user
        get :edit, params: {id: article.id}
        expect(response).to redirect_to '/articles'
      end
    end

    context 'ログインしていない場合' do
      it '302レスポンスが返ってきているか' do
        get :edit, params: {id: article.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされているか' do
        get :edit, params: {id: article.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'updateアクションのテスト' do
    context 'ログイン済の場合' do
      it '正常に記事を更新できるか' do
        sign_in user
        article = Article.create(user_id: user.id, title: '相方募集', content: '相方を探しています', area: '関東募集', category: '相方募集')
        patch :update, params: { id: article.id, article: {title: '友人募集'} }
        article.reload
        expect(article.title).to eq '友人募集'
      end
      it '記事を更新した後、更新された記事の詳細ページにリダイレクトするか' do
        sign_in user
        article = Article.create(user_id: user.id, title: '相方募集', content: '相方を探しています', area: '関東募集', category: '相方募集')
        patch :update, params: { id: article.id, article: {title: '友人募集'} }
        article.reload
        expect(response).to redirect_to "/articles/#{article.id}"
      end
      it '不正な属性を含む記事は更新できなくなっているか' do
        sign_in user
        article_params = {title: nil}
        article = Article.create(user_id: user.id, title: '相方募集', content: '相方を探しています', area: '関東募集', category: '相方募集')
        patch :update, params: { id: article.id, article: article_params }
        article.reload
        expect(article.reload.title).to eq "相方募集"
      end
      it '不正な記事を更新しようとすると、再度編集ページへリダイレクトされるか' do
        sign_in user
        article_params = {title: nil}
        article = Article.create(user_id: user.id, title: '相方募集', content: '相方を探しています', area: '関東募集', category: '相方募集')
        patch :update, params: { id: article.id, article: article_params }
        article.reload
        expect(response).to render_template :edit
      end
    end
    context '他のログイン済ユーザーの場合' do
      it '正常なレスポンスが返ってきていないか' do
        sign_in another_user
        get :edit, params: {id: article.id}
        expect(response).not_to be_successful
      end
      it '他のログイン済ユーザーが記事を編集しようとすると記事一覧ページへリダイレクトされているか' do
        sign_in another_user
        get :edit, params: {id: article.id}
        expect(response).to redirect_to '/articles'
      end
    end

    context 'ログインしていない場合' do
      it '302レスポンスを返すか' do
        article_params = {
          title: '相方募集',
          content: '相方を探しています',
          area: '中部エリア',
          category: '相方募集',
          user_id: 1
        }
        patch :update, params: {id: article.id, article: article_params}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされているか' do
        article_params = {
          title: '相方募集',
          content: '相方を探しています',
          area: '中部エリア',
          category: '相方募集',
          user_id: 1
        }
        patch :update, params: {id: article.id, article: article_params}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end

  describe 'destroyアクションのテスト' do
    context 'ログイン済のユーザー' do
      it '正常に記事を削除できるか' do
        sign_in user
        article = Article.create(user_id: user.id, title: '相方募集', content: '相方を探しています', area: '関東募集', category: '相方募集')
        expect {
          delete :destroy, params: {id: article.id}
        }.to change(user.articles, :count).by(-1)
      end
      it '記事を削除した後、記事一覧ページへリダイレクトしているか' do
        sign_in user
        delete :destroy, params: {id: article.id}
        expect(response).to redirect_to '/articles'
      end
    end

    context '他のログイン済ユーザーの場合' do
      it '記事を投稿したユーザーだけが記事を削除できるようになっているか' do
        sign_in user
        another_article = another_user.articles.create(
          title: "相方募集",
          content: '相方を探しています',
          area: '中部エリア',
          category: '相方募集',
          user_id: 1
        )
        expect {
          delete :destroy, params: {id: another_article.id}
        }.not_to change(another_user.articles, :count)
      end
      it '他のログイン済ユーザーが記事を削除しようとすると記事一覧ページへリダイレクトされるか' do
        sign_in user
        another_article = another_user.articles.create(
          title: "相方募集",
          content: '相方を探しています',
          area: '中部エリア',
          category: '相方募集',
          user_id: 1
        )
        delete :destroy, params: {id: another_article.id}
        expect(response).to redirect_to '/articles'
      end
    end

    context 'ログインしていない場合' do
      it '302レスポンスを返すか' do
        delete :destroy, params: {id: article.id}
        expect(response).to have_http_status '302'
      end
      it 'ログイン画面にリダイレクトされるか' do
        delete :destroy, params: {id: article.id}
        expect(response).to redirect_to '/users/sign_in'
      end
    end
  end
end