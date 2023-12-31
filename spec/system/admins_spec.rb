require 'rails_helper'

RSpec.describe 'Admins', type: :system do
  describe '管理者ログイン' do
    before do
      create(:admin, email: 'admin@example.com', password: 'passwordpassword', password_confirmation: 'passwordpassword')
    end

    context '認証情報が正しい場合' do
      it '管理者はログインすると、admins_rootにリダイレクトされる' do
        visit admins_root_path
        fill_in 'メールアドレス', with: 'admin@example.com'
        fill_in 'パスワード', with: 'passwordpassword'
        click_button 'Log in'
        expect(page).to have_current_path admins_root_path
      end
    end

    context '認証情報が正しくない場合' do
      it 'ログインに失敗するとログイン画面のまま' do
        visit admins_root_path
        fill_in 'メールアドレス', with: 'admin@example.com'
        fill_in 'パスワード', with: 'machigattapassword'
        click_button 'Log in'
        expect(page).to have_current_path new_admin_session_path
      end
    end
  end

  describe '管理者作成' do
    let!(:admin) { create(:admin) }

    it '管理者を作成できる' do
      login_as(admin, scope: :admin)
      visit admins_admins_path
      click_link '追加'
      expect(page).to have_current_path new_admins_admin_path
      fill_in 'メールアドレス', with: 'additional-admin@example.com'
      fill_in 'パスワード', with: 'passwordpassword'
      fill_in 'パスワード（確認）', with: 'passwordpassword'
      expect do
        click_button '作成する'
        expect(page).to have_current_path admins_admins_path
        expect(page).to have_content '管理者を作成しました'
      end.to change(Admin, :count).by(1)
      expect(Admin.find_by(email: 'additional-admin@example.com')).to be_present
    end
  end

  describe '管理者削除' do
    let!(:admin) { create(:admin) }

    before do
      create(:admin, email: 'admin-other@example.com')
    end

    it '自分以外の管理者を削除できる' do
      login_as(admin, scope: :admin)
      visit admins_admins_path
      expect do
        accept_confirm { click_button '削除', match: :first }
        expect(page).to have_current_path admins_admins_path
        expect(page).to have_content '管理者を削除しました'
      end.to change(Admin, :count).by(-1)
      expect(Admin.find_by(email: 'admin-other@example.com')).to be_blank
    end
  end

  describe 'ユーザー削除' do
    let!(:admin) { create(:admin) }

    before do
      create(:user, email: 'user@example.com')
    end

    it 'ユーザーを削除できる' do
      login_as(admin, scope: :admin)
      visit admins_users_path
      expect do
        accept_confirm { click_button '削除', match: :first }
        expect(page).to have_current_path admins_users_path
        expect(page).to have_content 'ユーザーを削除しました'
      end.to change(User, :count).by(-1)
      expect(User.find_by(email: 'user@example.com')).to be_blank
    end
  end
end
