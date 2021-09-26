=begin
require 'rails_helper'

RSpec.describe '回答機能のテスト', type: :system do
  describe '回答の投稿のテスト' do
    let(:user) { create(:user) }
    let!(:theme) { create(:theme, user: user) }
    let(:answer) {create(:answer, user: user)}
    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit new_theme_answer_path(theme.id)
    end
    content '回答の投稿に成功する場合' do
      before do
        fill_in 'answer[content]', with: Faker::Lorem.characters(number: 20)
      end
      it '自分の回答が正しく保存される' do
        expect{ click_button '回答する'}.to change(user.answers, :count).by(1)
      end
    end
  end
end
=end
