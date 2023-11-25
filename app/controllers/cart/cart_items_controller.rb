class Cart::CartItemsController < ApplicationController
  def create
    current_cart.add_cart_item(cart_item_params[:product_id], cart_item_params[:quantity])
    redirect_to cart_url, notice: '商品をカートに追加しました'
  end

  def update
    current_cart.cart_items.find(params[:id]).update_quantity!(cart_item_params[:quantity])
    redirect_to cart_url, notice: '商品個数を更新しました'
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end
end
