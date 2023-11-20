require 'rails_helper'

RSpec.describe 'Products', type: :system do
  describe '商品一覧操作' do
    let!(:user) { create(:user) }
    let!(:product) { create(:product, name: 'メープルパン', price: 98765, description: '美味しいパンです', disabled: false, position: 1) }

    context 'ユーザーがログインしていない場合' do
      it '商品を閲覧できる' do
        visit root_path
        click_link '詳細', match: :first
        expect(page).to have_current_path product_path(product)
      end
    end

    context 'ユーザーがログインしている場合' do
      it '商品を閲覧できる' do
        login_as(user, scope: :user)
        visit root_path
        expect(page).to have_current_path root_path
        click_link '詳細', match: :first
        expect(page).to have_current_path product_path(product)
      end
    end
  end
end
