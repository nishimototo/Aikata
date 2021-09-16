class HomesController < ApplicationController
  def top
    @articles = Article.limit(5).order(created_at: :DESC)
    @ranks = Answer.joins(:rates, :user).group(:user_id).select('answers.user_id, users.name as user_name, sum(rates.rate) as sum_rate').limit(5).order(sum_rate: :DESC)
  end
end
