require 'rails_helper'

RSpec.describe 'Carts', type: :system do
  let!(:user) { create(:user) }

  describe 'カートへ追加' do
    let!(:product) { create(:product, name: 'メープルパン', price: 98765, description: '美味しいパンです', disabled: false, position: 1) }
    let!(:other_product) { create(:product, name: '食パン', price: 3456, description: 'なんにでも使えます', disabled: false, position: 3) }
    let!(:disabled_product) { create(:product, name: 'レーズンパン', price: 12345, description: '好き嫌いの激しいパンです', disabled: true, position: 2) }

    context '未ログインの場合' do
      it 'ログインを求める' do
        visit root_path
        find(:data_selector, "product-show-link-#{product.id}").click
        click_button 'カートへ追加', match: :first
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'ログイン済みでカートがまだない場合' do
      it 'カートが作成され商品が追加される' do
        expect do
          login_as(user, scope: :user)
          visit root_path
          find(:data_selector, "product-show-link-#{product.id}").click

          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path cart_path
          expect(page).to have_content '商品をカートに追加しました'
        end.to change(CartItem, :count).by(1).and change(Cart, :count).by(1)

        cart = Cart.last
        expect(CartItem.find_by(cart_id: cart.id, product_id: product.id)).to be_present
      end
    end

    context 'ログイン済みでカートがある場合' do
      let!(:cart) { user.create_cart! }

      before do
        cart.cart_items.create!(product_id: product.id, quantity: 1)
      end

      it 'まだカートに入っていない商品が追加される' do
        login_as(user, scope: :user)
        visit root_path
        find(:data_selector, "product-show-link-#{other_product.id}").click
        expect(page).to have_content '食パン'

        expect do
          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path cart_path
          expect(page).to have_content '商品をカートに追加しました'
        end.to change(CartItem, :count).by(1).and not_change(Cart, :count)

        expect(CartItem.find_by(cart_id: cart.id, product_id: other_product.id)).to be_present
      end

      it 'すでにカートに入っている商品の個数が追加される' do
        login_as(user, scope: :user)
        visit root_path
        find(:data_selector, "product-show-link-#{product.id}").click
        expect(page).to have_content 'メープルパン'

        expect do
          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path cart_path
          expect(page).to have_content '商品をカートに追加しました'
        end.to not_change(CartItem, :count).and not_change(Cart, :count)

        expect(CartItem.find_by(cart_id: cart.id, product_id: product.id)).to be_present
      end
    end
  end

  describe 'カートの中身を変更' do
    let!(:product) { create(:product, name: 'メープルパン', price: 98765, description: '美味しいパンです', disabled: false, position: 1) }
    let!(:cart) { user.create_cart! }
    let!(:cart_item) { cart.cart_items.create!(product_id: product.id, quantity: 2) }

    it('カート内の商品の個数を追加する') do
      login_as(user, scope: :user)
      visit cart_path
      expect do
        find(:data_selector, "cart-item-plus-button-#{cart_item.id}").click
        expect(page).to have_content '個数: 3'
        expect(page).to have_content '小計（参考）: 325,924'  # (98765 * 3 = 296295) * 1.1 = 325924
        expect(page).to have_content '商品個数を更新しました'
      end.to change { cart_item.reload.quantity }.by(1)
    end

    it('カート内の商品の個数を減らす') do
      login_as(user, scope: :user)
      visit cart_path
      expect do
        find(:data_selector, "cart-item-minus-button-#{cart_item.id}").click
        expect(page).to have_content '個数: 1'
        expect(page).to have_content '小計（参考）: 108,641'  # 98765 * 1.1 = 108641
        expect(page).to have_content '商品個数を更新しました'
      end.to change { cart_item.reload.quantity }.by(-1)
    end

    it('カート内の商品を削除する') do
      login_as(user, scope: :user)
      visit cart_path
      expect do
        find(:data_selector, "cart-item-minus-button-#{cart_item.id}").click
        expect(page).to have_content '個数: 1'
        expect(page).to have_content '小計（参考）: 108,641'  # 98765 * 1.1 = 108641
        expect(page).to have_content '商品個数を更新しました'
      end.to change { cart_item.reload.quantity }.by(-1)

      expect do
        find(:data_selector, "cart-item-minus-button-#{cart_item.id}").click
        expect(page).not_to have_content 'メープルパン'
        expect(page).to have_content '商品をカートから削除しました'
      end.to change(CartItem, :count).by(-1)
    end
  end
end
