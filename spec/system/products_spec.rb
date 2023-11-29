require 'rails_helper'

RSpec.describe 'Products', type: :system do
  describe '商品一覧操作' do
    let!(:product) { create(:product, name: 'メープルパン', price: 98765, description: '美味しいパンです', disabled: false, position: 1) }

    before do
      create(:product, name: 'レーズンパン', price: 12345, description: '好き嫌いの激しいパンです', disabled: true, position: 2)
    end

    it '商品を閲覧できる' do
      visit root_path
      expect(page).to have_content 'メープルパン'
      expect(page).not_to have_content 'レーズンパン'
      find(:data_selector, "product-show-link-#{product.id}").click
      expect(page).to have_current_path product_path(product)
      expect(page).to have_content 'メープルパン'
      expect(page).to have_content '108,641円'  # 税込価格: (98765 * 1.1).floor
      expect(page).to have_content '98,765円'
      expect(page).to have_content '美味しいパンです'
    end
  end
end
