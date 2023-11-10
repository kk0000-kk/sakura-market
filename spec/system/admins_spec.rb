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

  describe '管理者作成' do
    let!(:admin) { create(:admin, email: 'admin@example.com', password: 'passwordpassword', password_confirmation: 'passwordpassword') }

    context '管理者でのログイン時' do
      it '管理者を作成できる' do
        login_as(admin, scope: :admin)
        visit admins_admins_path
        click_link '追加'
        expect(page).to have_current_path new_admins_admin_path
        fill_in 'Email', with: 'additional-admin@example.com'
        fill_in 'Password', with: 'passwordpassword'
        fill_in 'Password confirmation', with: 'passwordpassword'
        click_button '追加する'
        expect(page).to have_current_path admins_admins_path
        expect(Admin.find_by(email: 'additional-admin@example.com')).to be_present
      end
    end
  end

  describe '管理者削除' do
    let!(:admin) { create(:admin, email: 'admin@example.com', password: 'passwordpassword', password_confirmation: 'passwordpassword') }

    before do
      create(:admin, email: 'admin-2@example.com', password: 'passwordpassword', password_confirmation: 'passwordpassword')
    end

    context '管理者でのログイン時' do
      it '自分以外の管理者を削除できる' do
        login_as(admin, scope: :admin)
        visit admins_admins_path
        click_link 'delete'
        accept_confirm '削除しますが、よろしいですか?'
        expect(page).to have_current_path admins_admins_path
        expect(Admin.find_by(email: 'admin-2@example.com')).not_to be_present
      end
    end
  end
end
