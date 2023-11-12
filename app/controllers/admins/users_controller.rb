class Admins::UsersController < Admins::ApplicationController
  before_action :set_user, only: :destroy

  def index
    @users = User.order(:id).page(params[:page])
  end

  def destroy
    @user.destroy!
    redirect_to admins_users_url, status: :see_other, notice: 'ユーザーを削除しました'
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end
