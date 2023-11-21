class StaticPagesController < ApplicationController
  def index
    @products = Product.purchasable.order(:position).page(params[:page])
  end
end
