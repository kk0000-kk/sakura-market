require 'rails_helper'

RSpec.describe 'Admins Products', type: :system do
  describe '商品一覧操作' do
    let!(:admin) { create(:admin) }
    let!(:product) { create(:product, name: 'メープルパン') }

    it '商品を作成できる' do
      login_as(admin, scope: :admin)
      visit admins_products_path
      click_link '追加'
      expect(page).to have_current_path new_admins_product_path
      fill_in '商品名', with: '小倉ミルクパン'
      fill_in '価格（税抜）', with: 12345
      fill_in '説明', with: 'こだわりのミルクで作った美味しいパンです'
      uncheck '無効'
      fill_in '表示順', with: 1
      expect do
        click_button '作成する'
        expect(page).to have_content '商品を作成しました'
        expect(page).to have_current_path admins_products_path
      end.to change(Product, :count).by(1)
      expect(Product.find_by(name: '小倉ミルクパン')).to be_present
    end

    it '商品を編集できる' do
      login_as(admin, scope: :admin)
      visit admins_products_path
      click_link '編集', match: :first
      fill_in '商品名', with: 'レーズンミルクパン'
      fill_in '価格（税抜）', with: 54321
      fill_in '説明', with: 'こだわりのミルクで作った美味しいパンです'
      check '無効'
      fill_in '表示順', with: 2
      click_button '更新する'
      expect(page).to have_content '商品情報を更新しました'
      expect(page).to have_current_path admins_products_path
      expect(Product.find_by(name: 'レーズンミルクパン')).to be_present
    end

    it '商品を削除できる' do
      login_as(admin, scope: :admin)
      visit admins_products_path
      expect do
        accept_confirm { click_button '削除', match: :first }
        expect(page).to have_current_path admins_products_path
        expect(page).to have_content '商品を削除しました'
      end.to change(Product, :count).by(-1)
      expect(Product.find_by(name: 'メープルパン')).to be_blank
    end
  end
end
