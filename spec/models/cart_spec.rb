require 'rails_helper'

RSpec.describe 'Cart', type: :model do
  describe 'カートへの追加処理' do
    it('無効な商品は追加できない') do
      user = create(:user)
      cart = user.create_cart!
      disabled_product = create(:product, disabled: true)
      expect { cart.add_cart_item(disabled_product.id, 1) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end
end