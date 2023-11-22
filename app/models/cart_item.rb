class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    (quantity * product.price * 1.1).floor
  end
end
