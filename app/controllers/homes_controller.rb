class HomesController < ApplicationController
  def top
    @articles = Article.order(created_at: :DESC).limit(5)
    @ranks = Answer.joins(:rates, :user).group(:user_id).select('answers.user_id, users.name as user_name, sum(rates.rate) as sum_rate').order(sum_rate: :DESC).limit(5)
  end
end
