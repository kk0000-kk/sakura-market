class Admins::AdminsController < Admins::ApplicationController
  before_action :set_admin, only: %i[show edit update destroy]

  def index
    @admins = Admin.order(:id).page(params[:page])
  end

  def show
  end

  def new
    @admin = Admin.new
  end

  def edit
  end

  def create
    @admin = Admin.new(admin_params)

    if @admin.save
      redirect_to admins_admins_url, notice: '管理者を作成しました'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @admin.update(admin_params)
      redirect_to admins_admin_url(@admin), notice: '管理者の情報をアップデートしました'
    else
      render :edit, status: :unprocessable_entity
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
    params.require(:admins).permit(:email, :password, :password_confirmation)
  end
end
