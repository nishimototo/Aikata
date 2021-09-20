class ArticleComment < ApplicationRecord
  validates :comment, presence: true, length: {maximum: 150}

  belongs_to :user
  belongs_to :article
  has_many :notifications, dependent: :destroy
end
