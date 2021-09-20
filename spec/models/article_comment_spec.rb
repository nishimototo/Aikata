require 'rails_helper'

RSpec.describe 'ArticleCommentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { article_comment.valid? }

    let(:user) { create(:user) }
    let!(:article_comment) { build(:article_comment) }

    context 'commentカラム' do
      it '空欄でないこと' do
        article_comment.comment = ''
        is_expected.to eq false
      end
      it '150文字以内であること:150文字は〇' do
        article_comment.comment = Faker::Lorem.characters(number: 150)
        is_expected.to eq true
      end
      it '150文字以内であること:151文字は×' do
        article_comment.comment = Faker::Lorem.characters(number: 151)
        is_expected.to eq false
      end
    end


  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Theme.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Answerモデルとの関係' do
      it '1:Nとなっている' do
        expect(Theme.reflect_on_association(:answers).macro).to eq :has_many
      end
    end
  end
end