class Admins::StaticPagesController < Admins::ApplicationController
  skip_before_action :authenticate_admin!, only: :index

  def index
    redirect_to admins_home_path if admin_signed_in?
  end

  def home
  end
end
