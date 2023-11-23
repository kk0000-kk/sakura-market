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
        all('#product-show-link')[0].click
        click_button 'カートへ追加', match: :first
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'ログイン済みでカートがまだない場合' do
      it 'カートが作成され商品が追加される' do
        login_as(user, scope: :user)
        visit root_path
        all('#product-show-link')[0].click

        expect do
          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path root_path
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
        all('#product-show-link')[1].click
        expect(page).to have_content '食パン'

        expect do
          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path root_path
          expect(page).to have_content '商品をカートに追加しました'
        end.to change(CartItem, :count).by(1).and not_change(Cart, :count)

        expect(CartItem.find_by(cart_id: cart.id, product_id: other_product.id)).to be_present
      end

      it 'すでにカートに入っている商品の個数が追加される' do
        login_as(user, scope: :user)
        visit root_path
        all('#product-show-link')[0].click
        expect(page).to have_content 'メープルパン'

        expect do
          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path root_path
          expect(page).to have_content '商品をカートに追加しました'
        end.to not_change(CartItem, :count).and not_change(Cart, :count)

        expect(CartItem.find_by(cart_id: cart.id, product_id: product.id)).to be_present
      end
    end
  end
end
