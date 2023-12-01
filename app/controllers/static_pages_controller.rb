class StaticPagesController < ApplicationController
  skip_before_action :authenticate_user!, only: :index

  def index
    @products = Product.purchasable.order(:position).page(params[:page])
  end
end
