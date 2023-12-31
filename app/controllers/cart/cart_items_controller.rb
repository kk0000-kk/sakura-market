class Cart::CartItemsController < ApplicationController
  before_action :set_cart_item, only: %i[update]

  MIN_QUANTITY = 1

  def create
    quantity = [cart_item_params[:quantity].to_i, MIN_QUANTITY].max
    product = Product.purchasable.find(cart_item_params[:product_id])
    current_cart.add_cart_item(product, quantity)
    redirect_to cart_url, notice: '商品をカートに追加しました'
  end

  def update
    quantity = [cart_item_params[:quantity].to_i, 0].max
    if quantity == 0
      @cart_item.destroy!
      redirect_to cart_url, notice: '商品をカートから削除しました'
    else
      @cart_item.update!(quantity:)
      redirect_to cart_url, notice: '商品個数を更新しました'
    end
  end

  private

  def cart_item_params
    params.require(:cart_item).permit(:product_id, :quantity)
  end

  def set_cart_item
    @cart_item = current_cart.cart_items.find(params[:id])
  end
end
