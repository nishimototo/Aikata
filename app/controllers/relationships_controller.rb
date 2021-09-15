class RelationshipsController < ApplicationController
  before_action :authenticate_user!

  def create
    @user = User.find(params[:user_id])
    @follow = current_user.active_relationships.new(follower_id: @user.id)
    @follow.save
    @user.create_notification_follow!(current_user) #フォローしたら通知を作成。user.rbで定義
  end

  def destroy
    @user = User.find(params[:user_id])
    @follow = current_user.active_relationships.find_by(follower_id: @user.id)
    @follow.destroy
  end
end
