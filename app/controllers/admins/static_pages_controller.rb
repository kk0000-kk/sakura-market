class Admins::StaticPagesController < Admins::ApplicationController
  before_action :authenticate_admin!, only: :home

  def index
    redirect_to admins_home_path if admin_signed_in?
  end

  def home
  end
end
