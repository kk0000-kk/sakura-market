class Admins::AdminsController < Admins::ApplicationController
  before_action :set_admin, only: :destroy

  def index
    @admins = Admin.order(:id).page(params[:page])
  end

  def new
    @admin = Admin.new
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to admins_admins_url, notice: '管理者を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @admin.destroy!
    redirect_to admins_admins_url, status: :see_other, notice: '管理者を削除しました'
  end

  private

  def set_admin
    @admin = Admin.find(params[:id])
  end

  def admin_params
    params.require(:admin).permit(:email, :password, :password_confirmation)
  end
end
