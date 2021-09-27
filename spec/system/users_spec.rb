require 'rails_helper'

RSpec.describe 'ユーザー機能のテスト', type: :system do
  describe 'マイページ(ユーザー詳細画面)のテスト' do
    let(:user) { create(:user) }
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit user_path(user.id)
    end

    context '表示内容の確認:ログイン済の場合' do
      it 'URLが正しい' do
        expect(current_path).to eq "/users/#{user.id}"
      end
      it 'フォローをクリックするとユーザーのフォロー一覧へ遷移する' do
        follow_link = find_all('a')[8].native.inner_text
        follow_link = follow_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link follow_link
        expect(current_path).to eq "/users/#{user.id}/follows"
      end
      it 'フォロワーをクリックするとユーザーのフォロワー一覧へ遷移する' do
        follower_link = find_all('a')[9].native.inner_text
        follower_link = follower_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link follower_link
        expect(current_path).to eq "/users/#{user.id}/followers"
      end
      it '通知の部分をクリックする通知一覧へ遷移する' do
        notification_link = find_all('a')[10].native.inner_text
        notification_link = notification_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link notification_link
        expect(current_path).to eq "/notifications"
      end
      it 'プロフィール更新をクリックするプロフィール編集画面へ遷移する' do
        edit_mypage_link = find_all('a')[11].native.inner_text
        edit_mypage_link = edit_mypage_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link edit_mypage_link
        expect(current_path).to eq "/users/#{user.id}/edit"
      end
      it '退会するをクリックすると退会確認画面へ遷移する' do
        unsubscribe_link = find_all('a')[12].native.inner_text
        unsubscribe_link = unsubscribe_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link unsubscribe_link
        expect(current_path).to eq "/users/#{user.id}/unsubscribe"
      end
      it '大喜利一覧へをクリックするとそのユーザーの大喜利一覧画面へ遷移する' do
        my_answer_link = find_all('a')[13].native.inner_text
        my_answer_link = my_answer_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link my_answer_link
        expect(current_path).to eq "/users/#{user.id}/my_answer"
      end
    end

    context '退会画面のテスト' do
      before do
        visit unsubscribe_user_path(user.id)
      end
      it '退会しないを押すとマイページに遷移する' do
        back_link = find_all('a')[9].native.inner_text
        back_link = back_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link back_link
        expect(current_path).to eq "/users/#{user.id}"
      end
      it '退会するを押すとトップ画面に遷移する' do
        withdraw_link = find_all('a')[8].native.inner_text
        withdraw_link = withdraw_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link withdraw_link
        expect(current_path).to eq "/"
      end
       it '退会するとログインができなくなり、再度ログイン画面にリダイレクトされる' do
        withdraw_link = find_all('a')[8].native.inner_text
        withdraw_link = withdraw_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link withdraw_link
        visit new_user_session_path
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'ログイン'
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end
end