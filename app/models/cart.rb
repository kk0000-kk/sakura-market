class Cart < ApplicationRecord
  belongs_to :user

  has_many :cart_items, dependent: :destroy

  def add_cart_item(product, quantity)
    cart_item = cart_items.find_or_create_by(product:)
    cart_item.quantity = (cart_item.quantity || 0) + quantity.to_i
    cart_item.save!
  end

  def total_price
    cart_items.sum(&:subtotal)
  end

  def total_price_with_tax
    (total_price * TAX_FACTOR).floor
  end
end
