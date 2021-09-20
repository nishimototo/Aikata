require 'rails_helper'

RSpec.describe 'Answerモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { answer.valid? }

    let(:user) { create(:user) }
    let!(:answer) { build(:answer) }

    context 'contentカラム' do
      it '空欄でないこと' do
        answer.content = ''
        is_expected.to eq false
      end

      it '120文字以内であること:120文字は〇' do
        answer.content = Faker::Lorem.characters(number: 120)
        is_expected.to eq true
      end
      it '120文字以内であること:120文字は×' do
        answer.content = Faker::Lorem.characters(number: 121)
        is_expected.to eq false
      end
    end
  end

  describe 'アソシエーションのテスト' do
    context 'Userモデルとの関係' do
      it 'N:1となっている' do
        expect(Answer.reflect_on_association(:user).macro).to eq :belongs_to
      end
    end
    context 'Themeモデルとの関係' do
      it 'N:1となっている' do
        expect(Answer.reflect_on_association(:theme).macro).to eq :belongs_to
      end
    end
    context 'Commentモデルとの関係' do
      it '1:Nとなっている' do
        expect(Answer.reflect_on_association(:comments).macro).to eq :has_many
      end
    end
    context 'Rateモデルとの関係' do
      it '1:Nとなっている' do
        expect(Answer.reflect_on_association(:rates).macro).to eq :has_many
      end
    end
  end
end