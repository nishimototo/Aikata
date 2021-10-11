require 'rails_helper'

RSpec.describe 'Articleモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { article.valid? }

    let(:user) { create(:user) }
    let!(:article) { build(:article) }

    context 'titleカラム' do
      it '空欄でないこと' do
        article.title = ''
        is_expected.to eq false
      end
      it '80文字以内であること:80文字は〇' do
        article.title = Faker::Lorem.characters(number: 80)
        is_expected.to eq true
      end
      it '80文字以内であること:81文字は×' do
        article.title = Faker::Lorem.characters(number: 81)
        is_expected.to eq false
      end
    end

    context 'contentカラム' do
      it '空欄でないこと' do
        article.content = ''
        is_expected.to eq false
      end

      it '1200文字以内であること:1200文字は〇' do
        article.content = Faker::Lorem.characters(number: 1200)
        is_expected.to eq true
      end
      it '1200文字以内であること:1200文字は×' do
        article.content = Faker::Lorem.characters(number: 1201)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Article.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Favoriteモデルとの関係' do
      it '1:Nとなっている' do
        expect(Article.reflect_on_association(:favorites).macro).to eq :has_many
      end
    end

    context 'ArticleCommentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Article.reflect_on_association(:article_comments).macro).to eq :has_many
      end
    end

    context 'Notificationモデルとの関係' do
      it '1:Nとなっている' do
        expect(Article.reflect_on_association(:notifications).macro).to eq :has_many
      end
    end
  end
end
