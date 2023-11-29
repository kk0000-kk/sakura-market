class ProductsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  def index
    @products = Product.purchasable.order(:position).page(params[:page])
  end

  def show
    @product = Product.purchasable.find(params[:id])
    if user_signed_in? && current_cart.cart_items
      cart_item = current_cart.cart_items.find_by(product_id: @product.id)
      @cart_item_quantity = cart_item ? cart_item.quantity : 0
    else
      @cart_item_quantity = 0
    end
  end
end
