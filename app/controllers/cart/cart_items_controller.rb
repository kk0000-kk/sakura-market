class Cart::CartItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    return redirect_to root_url, alert: 'この商品は購入できません' unless enable_product?

    cart_item = current_cart.cart_items.find_by(product_id: cart_item_params[:product_id])
    if cart_item
      cart_item.update(quantity: cart_item.quantity + cart_item_params[:quantity].to_i)
    else
      current_cart.cart_items.create!(cart_item_params)
    end
    redirect_to root_url, notice: '商品をカートに追加しました'
  end

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def enable_product?
    Product.purchasable.find_by(id: cart_item_params[:product_id])
  end
end
