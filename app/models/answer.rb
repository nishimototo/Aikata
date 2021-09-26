class Answer < ApplicationRecord
  validates :content, presence: true, length: { maximum: 120 }

  belongs_to :user
  belongs_to :theme
  has_many :comments
  has_many :rates

  def rated_by?(user)
    rates.find_by(user_id: user.id).present?
  end

  def self.rate_count(num = 7)
    answers = if Rails.env.development?
                joins(:rates).select("answers.user_id, STRFTIME('%Y-%m-%d', rates.created_at) as rate_created_at, sum(rates.rate) as sum_rate")
              else
                joins(:rates).select("answers.user_id, DATE_FORMAT(rates.created_at, '%Y-%m-%d') as rate_created_at, sum(rates.rate) as sum_rate")
              end
    answers.group_by_day('rates.created_at').order('rates.created_at').limit(num)
  end
end
