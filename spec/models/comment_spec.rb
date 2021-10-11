require 'rails_helper'

RSpec.describe 'Commentモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { comment.valid? }

    let(:user) { create(:user) }
    let!(:comment) { build(:comment) }

    context 'commentカラム' do
      it '空欄でないこと' do
        comment.comment = ''
        is_expected.to eq false
      end

      it '100文字以内であること:100文字は〇' do
        comment.comment = Faker::Lorem.characters(number: 100)
        is_expected.to eq true
      end
      it '100文字以内であること:101文字は×' do
        comment.comment = Faker::Lorem.characters(number: 101)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end

    context 'Answerモデルとの関係' do
      it 'N:1となっている' do
        expect(Comment.reflect_on_association(:answer).macro).to eq :belongs_to
      end
    end
  end
end
