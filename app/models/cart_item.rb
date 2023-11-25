class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def subtotal
    quantity * product.price
  end

  def subtotal_with_tax
    (subtotal * TAX_FACTOR).floor
  end
end
