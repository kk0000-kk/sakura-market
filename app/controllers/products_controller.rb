class ProductsController < ApplicationController
  def index
    @products = Product.where(disabled: false).order(:position).page(params[:page])
  end

  def show
    @product = Product.find(params[:id])
  end
end
