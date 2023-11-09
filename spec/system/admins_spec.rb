require 'rails_helper'

RSpec.describe 'Admins', type: :system do
  describe '管理者ログイン' do
    before do
      create(:admin, email: 'admin@example.com', password: 'passwordpassword', password_confirmation: 'passwordpassword')
    end

    context '認証情報が正しい場合' do
      it '管理者はログインすると、admins_rootにリダイレクトされる' do
        visit admins_root_path
        fill_in 'Email', with: 'admin@example.com'
        fill_in 'Password', with: 'passwordpassword'
        click_button 'Log in'
        expect(page).to have_current_path admins_root_path
      end
    end

    context '認証情報が正しくない場合' do
      it 'ログインに失敗するとログイン画面のまま' do
        visit admins_root_path
        fill_in 'Email', with: 'admin@example.com'
        fill_in 'Password', with: 'machigattapassword'
        click_button 'Log in'
        expect(page).to have_current_path new_admin_session_path
      end
    end
  end
end
