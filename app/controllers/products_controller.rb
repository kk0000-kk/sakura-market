class ProductsController < ApplicationController
  def index
    @products = Product.purchasable.order(:position).page(params[:page])
  end

  def show
    @product = Product.purchasable.find(params[:id])
  end
end
