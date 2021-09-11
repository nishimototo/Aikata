module NotificationsHelper
  def notification_form(notification)
    @visitor = notification.visitor
    @comment = nil
    #your_article = link_to "あなたの投稿", article_path(notification)+
    @visitor_comment = notification.comment_id
    case notification.action
      when "follow" then
        tag.a(notification.visitor.name, href: user_path(@visitor))  + "さんがあなたをフォローしました"
      when "favorite" then
        tag.a(notification.visitor.name, href: user_path(@visitor)) + "さんが" + tag.a('あなたの投稿', href: article_path(notification.article_id)) + "にいいねしました"
      when "comment" then
        @comment = ArticleComment.find_by(id: @visitor_comment)&.comment
        tag.a(@visitor.name, href: user_path(@visitor)) + "さんが" + tag.a('あなたの投稿', href: article_path(notification.article_id)) + "にコメントしました"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
