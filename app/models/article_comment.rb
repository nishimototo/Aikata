class ArticleComment < ApplicationRecord
  validates :comment, presence: true

  belongs_to :user
  belongs_to :article
  has_many :notifications, dependent: :destroy
end
