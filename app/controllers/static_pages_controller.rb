class StaticPagesController < ApplicationController
  def index
    @products = Product.where(disabled: false).order(:position).page(params[:page])
  end
end
