class Cart::CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    current_cart.add_cart_item(cart_item_params[:product_id], cart_item_params[:quantity])
    redirect_to root_url, notice: '商品をカートに追加しました'
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
