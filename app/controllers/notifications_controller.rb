class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.passive_notifications.where.not(visitor_id: current_user.id).page(params[:page]).per(10) #相手からの通知を取得。自身のものは除く
    @notifications.where(checked: false).each do |notification| #@notificationの中でまだ確認していない（indexページにアクセスしていない）通知だけを取り出して通知済にupdate
      notification.update(checked: true)
    end
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to request.referer
  end
end
