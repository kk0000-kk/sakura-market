class Cart < ApplicationRecord
  belongs_to :user

  has_many :cart_items, dependent: :destroy

  def add_cart_item(product_id, quantity)
    product = Product.purchasable.find(product_id)
    cart_item = cart_items.find_by(product:)
    if cart_item
      cart_item.update!(quantity: cart_item.quantity + quantity.to_i)
    else
      cart_items.create!(product_id:, quantity:)
    end
  end

  def total_price
    cart_items.sum(&:subtotal)
  end

  def total_price_with_tax
    (total_price * TAX_FACTOR).floor
  end
end
