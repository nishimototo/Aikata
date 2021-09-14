class Article < ApplicationRecord
  is_impressionable

  validates :title, presence: true
  validates :content, presence: true

  belongs_to :user
  has_many :favorites
  has_many :article_comments
  has_many :notifications, dependent: :destroy

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  #いいね通知
  def create_notification_favorite!(current_user)
    temp = Notification.where(["visitor_id = ? AND visited_id = ? AND article_id = ? AND action = ? ", current_user.id, user_id, id, 'favorite']) #既にいいねされているかの分岐用
    if temp.blank?
      notification = current_user.active_notifications.new(article_id: id, visited_id: user_id, action: 'favorite')
      if notification.visitor_id == notification.visited_id #自分で自分の記事にいいねするときは通知済に
        notification.checked = true
      end

      notification.save if notification.valid?
    end
  end

  #コメント通知
  def create_notification_comment!(current_user, comment_id)
    temp_ids = ArticleComment.select(:user_id).where(article_id: id).where.not(user_id: current_user.id).distinct #コメントしている人のuser_idを重複なしで取得（自分がコメントした分は除く）
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    save_notification_comment!(current_user, comment_id, user_id)
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    notification = current_user.active_notifications.new(article_id: id, article_comment_id: comment_id, visited_id: visited_id, action: 'comment')
    if notification.visitor_id == notification.visited_id #自分で自分の記事にコメントするときは通知済に
      notification.checked = true
    end

    notification.save if notification.valid?
  end
end
