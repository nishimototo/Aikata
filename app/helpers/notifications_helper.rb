module NotificationsHelper
  def notification_form(notification)
    @visitor = notification.visitor
    #@comment = nil
    @visitor_comment = notification.comment_id
    if notification.action == "follow"
        tag.a(notification.visitor.name, href: user_path(@visitor))  + "さんがあなたをフォローしました"
    elsif notification.action == "favorite"
        tag.a(notification.visitor.name, href: user_path(@visitor)) + "さんが" + tag.a('あなたの投稿', href: article_path(notification.article_id)) + "にいいねしました"
    elsif notification.action == "comment"
        @comment = ArticleComment.find_by(id: @visitor_comment)&.comment
        tag.a(@visitor.name, href: user_path(@visitor)) + "さんが" + tag.a('あなたの投稿', href: article_path(notification.article_id)) + "にコメントしました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
