class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, numericality: { only_integer: true, greater_than: 0 }

  def update_quantity!(additional_quantity)
    new_quantity = quantity + additional_quantity.to_i
    new_quantity.positive? ? update!(quantity: new_quantity) : destroy!
  end

  def subtotal
    quantity * product.price
  end

  def subtotal_with_tax
    (subtotal * TAX_FACTOR).floor
  end
end
