require 'rails_helper'

RSpec.describe 'Themeモデルのテスト', type: :model do
  describe 'バリデーションのテスト' do
    subject { theme.valid? }

    let(:user) { create(:user) }
    let!(:theme) { build(:theme) }

    context 'contentカラム' do
      it '空欄でないこと' do
        theme.content = ''
        is_expected.to eq false
      end
      it '120文字以内であること:120文字は〇' do
        theme.content = Faker::Lorem.characters(number: 120)
        is_expected.to eq true
      end
      it '120文字以内であること:121文字は×' do
        theme.content = Faker::Lorem.characters(number: 121)
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
