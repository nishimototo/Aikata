class Answer < ApplicationRecord
  validates :content, presence: true, length: {maximum: 120}

  belongs_to :user
  belongs_to :theme
  has_many :comments
  has_many :rates
  #has_many :rate_users, through: :rates, source: :user

  def rated_by?(user)
    rates.find_by(user_id: user.id).present?
  end
end
