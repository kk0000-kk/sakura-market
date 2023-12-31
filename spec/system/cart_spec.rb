require 'rails_helper'

RSpec.describe 'Carts', type: :system do
  let!(:user) { create(:user) }

  describe 'カート作成' do
    context 'ログイン済みでカートがまだない場合' do
      it 'カートが作成される' do
        login_as(user, scope: :user)
        expect do
          # ヘッダーでカートの情報を使っているので表示時点でカートが作成される
          visit root_path
        end.to change(Cart, :count).by(1)
      end
    end
  end

  describe 'カートへ追加' do
    context '未ログインの場合' do
      let!(:product) { create(:product, name: 'メープルパン', price: 98765, description: '美味しいパンです', disabled: false, position: 1) }

      it 'ログインを求める' do
        visit root_path
        find(:data_selector, dom_id(product, :show_link)).click
        click_button 'カートへ追加', match: :first
        expect(page).to have_current_path new_user_session_path
      end
    end

    context 'ログイン済みでカートがある場合' do
      let!(:cart) { user.create_cart! }
      let!(:product) { create(:product, name: 'メープルパン', price: 98765, description: '美味しいパンです', disabled: false, position: 1) }
      let!(:other_product) { create(:product, name: '食パン', price: 3456, description: 'なんにでも使えます', disabled: false, position: 3) }

      before do
        cart.cart_items.create!(product_id: product.id, quantity: 1)
      end

      it 'まだカートに入っていない商品が追加される' do
        login_as(user, scope: :user)
        visit product_path(other_product)

        expect do
          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path cart_path
          expect(page).to have_content '商品をカートに追加しました'
        end.to change(CartItem, :count).by(1).and not_change(Cart, :count)

        expect(page).to have_content '食パン'
        expect(page).to have_content '3,456円（税抜）'
        expect(page).to have_content 'なんにでも使えます'
        expect(page).to have_content '個数: 1'
        expect(page).to have_content '小計（参考）: 3,801円（税込）' # 税込価格: (3456 * 1.1).floor
        expect(page).to have_content '合計: 112,443円（税込）' # (98765 + 3456) * 1.1
        expect(page).to have_content '102,221円（税抜）' # 合計の税抜: 98765 + 3456

        expect(cart.cart_items.find_by(product: other_product)).to be_present
      end

      it 'すでにカートに入っている商品の個数が追加される' do
        login_as(user, scope: :user)
        visit product_path(product)

        expect do
          click_button 'カートへ追加', match: :first
          expect(page).to have_current_path cart_path
          expect(page).to have_content '商品個数を更新しました'
        end.to not_change(CartItem, :count).and not_change(Cart, :count)

        expect(page).to have_content 'メープルパン'
        expect(page).to have_content '98,765円（税抜）'
        expect(page).to have_content '美味しいパンです'
        expect(page).to have_content '個数: 2'
        expect(page).to have_content '小計（参考）: 217,283円（税込）' # 税込価格: (98765 * 2 * 1.1).floor
        expect(page).to have_content '合計: 217,283円（税込）'
        expect(page).to have_content '197,530円（税抜）' # 合計の税抜: 98765 * 2

        expect(cart.cart_items.find_by(product:)).to be_present
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
        find(:data_selector, dom_id(cart_item, :plus_button)).click
        expect(page).to have_content '商品個数を更新しました'
      end.to change { cart_item.reload.quantity }.by(1)

      expect(page).to have_content '個数: 3'
      expect(page).to have_content '小計（参考）: 325,924'  # (98765 * 3 = 296295) * 1.1 = 325924
    end

    it('カート内の商品の個数を減らして削除') do
      login_as(user, scope: :user)
      visit cart_path
      expect do
        find(:data_selector, dom_id(cart_item, :minus_button)).click
        expect(page).to have_content '商品個数を更新しました'
      end.to change { cart_item.reload.quantity }.by(-1)

      expect(page).to have_content '個数: 1'
      expect(page).to have_content '小計（参考）: 108,641'  # 98765 * 1.1 = 108641

      expect do
        find(:data_selector, dom_id(cart_item, :minus_button)).click
        expect(page).to have_content '商品をカートから削除しました'
      end.to change(CartItem, :count).by(-1)

      expect(page).not_to have_content 'メープルパン'
    end
  end
end
