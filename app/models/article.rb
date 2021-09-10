class Article < ApplicationRecord
  is_impressionable

  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user
  has_many :favorites
  has_many :article_comments

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end
end
