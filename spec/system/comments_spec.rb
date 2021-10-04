require 'rails_helper'

RSpec.describe '回答へのコメント機能のテスト', type: :system do
  describe '回答に対するコメントの投稿テスト' do
    let(:user) { create(:user) }
    let!(:theme) { create(:theme, user: user) }
    let!(:answer) { create(:answer, user: user) }
    let(:comment) { create(:comment, user: user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'ログイン'
      visit  theme_answer_path(theme_id: theme.id, id: answer.id)
    end
    context 'コメントの投稿に成功する場合' do
      before do
        fill_in 'comment[comment]', with: Faker::Lorem.characters(number: 20)
      end
      it '自分のコメントが正しく保存される' do
        expect{ click_button 'コメント'}.to change(user.comments, :count).by(1)
      end
    end
    context 'コメントの投稿に失敗する場合' do
      before do
        fill_in 'comment[comment]', with: ''
      end
      it '自分のコメントが正しく保存されない' do
        expect{ click_button 'コメント'}.not_to change(user.comments, :count)
      end
    end
  end
end