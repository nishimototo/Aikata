require 'rails_helper'

describe 'ログイン前のテスト' do
  describe 'トップ画面とヘッダーのテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'トップ画面のURLが正しい' do
        expect(current_path). to eq '/'
      end
      it 'サイトタイトルが表示される' do
        expect(page).to have_content 'Aikata'
      end
      it 'ログインリンクが表示される: 左から1番目のリンクが「ログイン」である' do
        login_link = find_all('a')[1].native.inner_text
        expect(login_link).to match(/ログイン/i)
      end
      it 'ログインリンクの内容が正しい' do
        log_in_link = find_all('a')[1].native.inner_text
        expect(page).to have_link log_in_link, href: new_user_session_path
      end
      it '新規登録リンクが表示される: 左から2番目のリンクが「新規登録」である' do
        sign_up_link = find_all('a')[2].native.inner_text
        expect(sign_up_link).to match(/新規登録/i)
      end
      it '新規登録リンクの内容が正しい' do
        sign_up_link = find_all('a')[2].native.inner_text
        expect(page).to have_link sign_up_link, href: new_user_registration_path
      end
      it '募集一覧リンクが表示される: 左から3番目のリンクが「募集一覧」である' do
        article_link = find_all('a')[3].native.inner_text
        expect(article_link).to match(/募集一覧/i)
      end
      it '募集一覧リンクの内容が正しい' do
        article_link = find_all('a')[3].native.inner_text
        expect(page).to have_link article_link, href: articles_path
      end
      it 'お題一覧リンクが表示される: 左から4番目のリンクが「お題一覧」である' do
        theme_link = find_all('a')[4].native.inner_text
        expect(theme_link).to match(/お題一覧/i)
      end
      it 'お題一覧リンクの内容が正しい' do
        theme_link = find_all('a')[4].native.inner_text
        expect(page).to have_link theme_link, href: themes_path
      end
      it 'お問い合わせリンクが表示される: 左から5番目のリンクが「お問い合わせ」である' do
        contact_link = find_all('a')[5].native.inner_text
        expect(contact_link).to match(/お問い合わせ/i)
      end
      it 'お問い合わせリンクの内容が正しい' do
        contact_link = find_all('a')[5].native.inner_text
        expect(page).to have_link contact_link, href: new_contact_path
      end
    end
  end

  describe 'ユーザー新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示の内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '新規登録と表示される' do
        expect(page).to have_content '新規登録'
      end
      it '名前の入力欄がある' do
        expect(page).to have_field 'user[name]'
      end
      it 'メールアドレスの入力欄が表示されている' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードの入力欄が表示されている' do
        expect(page).to have_field 'user[password]'
      end
      it 'パスワード再入力の入力欄が表示されている' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it '新規登録ボタンが表示されている' do
        expect(page).to have_button '新規登録'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end
      it '正しく登録される' do
        expect {click_button '新規登録'}.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、トップ画面になっている' do
        click_button '新規登録'
        expect(current_path).to eq '/'
      end
    end
  end

  describe 'ユーザーログインのテスト' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「ログイン」と表示される' do
        expect(page).to have_content 'ログイン'
      end
      it 'メールアドレスの入力欄が表示されている' do
        expect(page).to have_field 'user[email]'
      end
      it 'パスワードの入力欄が表示されている' do
        expect(page).to have_field 'user[password]'
      end
      it 'ログインボタンが表示されている' do
        expect(page).to have_button 'ログイン'
      end
      it '名前の入力欄は表示されない' do
        expect(page).not_to have_field 'user[name]'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
      end

      it 'ログイン後のリダイレクト先がトップ画面になっている' do
        expect(current_path).to eq '/'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'ログイン'
      end

      it 'ログインに失敗するとログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト（ログイン済の場合）' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
    end

    context 'ヘッダーの表示の確認' do
      it 'サイトタイトルが表示される' do
        expect(page).to have_content 'Aikata'
      end
      it 'ログアウトリンクが表示される: 左から1番目のリンクが「ログアウト」である' do
        logout_link = find_all('a')[1].native.inner_text
        expect(logout_link).to match(/ログアウト/i)
      end
      it 'ログアウトリンクの内容が正しい' do
        logout_link = find_all('a')[1].native.inner_text
        expect(page).to have_link logout_link, href: destroy_user_session_path
      end
      it 'マイページリンクが表示される: 左から2番目のリンクが「マイページ」である' do
        mypage_link = find_all('a')[2].native.inner_text
        expect(mypage_link).to match(/マイページ/i)
      end
      it 'マイページリンクの内容が正しい' do
        mypage_link = find_all('a')[2].native.inner_text
        expect(page).to have_link mypage_link, href: user_path(user.id)
      end

      it '募集するリンクが表示される: 左から3番目のリンクが「募集する」である' do
        new_article_link = find_all('a')[3].native.inner_text
        expect(new_article_link).to match(/募集する/i)
      end
      it '募集するリンクの内容が正しい' do
        new_article_link = find_all('a')[3].native.inner_text
        expect(page).to have_link new_article_link, href: new_article_path
      end
      it '募集一覧リンクが表示される: 左から4番目のリンクが「募集一覧」である' do
        article_link = find_all('a')[4].native.inner_text
        expect(article_link).to match(/募集一覧/i)
      end
      it '募集一覧リンクの内容が正しい' do
        article_link = find_all('a')[4].native.inner_text
        expect(page).to have_link article_link, href: articles_path
      end
      it 'お題一覧リンクが表示される: 左から5番目のリンクが「お題一覧」である' do
        theme_link = find_all('a')[5].native.inner_text
        expect(theme_link).to match(/お題一覧/i)
      end
      it 'お題一覧リンクの内容が正しい' do
        theme_link = find_all('a')[5].native.inner_text
        expect(page).to have_link theme_link, href: themes_path
      end
      it 'お問い合わせリンクが表示される: 左から6番目のリンクが「お問い合わせ」である' do
        contact_link = find_all('a')[6].native.inner_text
        expect(contact_link).to match(/お問い合わせ/i)
      end
      it 'お問い合わせリンクの内容が正しい' do
        contact_link = find_all('a')[6].native.inner_text
        expect(page).to have_link contact_link, href: new_contact_path
      end
    end
  end

  describe 'ログアウトのテスト' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      logout_link = find_all('a')[1].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end
    context 'ログアウト機能のテスト' do
      it '正しくログアウトできている:ログアウト後のリダイレクト先にログインリンクが表示されている' do
        login_link = find_all('a')[1].native.inner_text
        expect(page).to have_link login_link, href:  new_user_session_path
      end
      it 'ログアウト後のリダイレクト先がトップ画面になっている' do
        expect(current_path).to eq '/'
      end
    end
  end


end