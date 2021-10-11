class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  validates :name, presence: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 100 }

  has_many :articles, dependent: :destroy
  has_many :themes, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :rates, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :article_comments, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: :visitor_id, dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: :visited_id, dependent: :destroy

  has_many :active_relationships, class_name: "Relationship", foreign_key: :following_id, dependent: :destroy
  has_many :followings, through: :active_relationships, source: :follower
  has_many :passive_relationships, class_name: "Relationship", foreign_key: :follower_id, dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :following

  has_many :user_rooms, dependent: :destroy
  has_many :chats, dependent: :destroy

  def active_for_authentication?
    super && (is_deleted == false)
  end

  def followed_by?(user)
    passive_relationships.where(following_id: user.id).exists?
  end

  # フォロー通知
  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? AND visited_id = ? AND action = ? ", current_user.id, id, 'follow']) # 既にフォロー済かの分岐用
    if temp.blank?
      notification = current_user.active_notifications.new(visited_id: id, action: 'follow')
      notification.save if notification.valid?
    end
  end

  def me?(user_id) # user == current_userなど定義したい時用
    id == user_id
  end

  def rate_count(num = 7) # answer.rbで定義したクラスrate_countをdef内で使用
    answers.rate_count.map { |count| [count.rate_created_at, count.sum_rate] }
  end
end
