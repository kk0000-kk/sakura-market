class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @products = Product.purchasable.order(:position).page(params[:page])
  end

  def show
    @product = Product.purchasable.find(params[:id])
  end
end
