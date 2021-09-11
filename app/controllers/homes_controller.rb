class HomesController < ApplicationController
  def top
    @articles = Article.limit(5).order(created_at: :DESC)
    @users = User.limit(5).includes(:rates).sort{|a,b| b.rates.sum(:rate) <=> a.rates.sum(:rate)} #星の数の合計が多いユーザー5人を選ぶ
  end
end
