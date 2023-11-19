require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ユーザーログイン' do
    let!(:user) { create(:user, email: 'user@example.com', password: 'passwordpassword', password_confirmation: 'passwordpassword', nick_name: 'ニック') }

    context '認証情報が正しい場合' do
      it 'ユーザーはログインすると、/にリダイレクトされる' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'passwordpassword'
        click_button 'Log in'
        expect(page).to have_current_path root_path
      end

      it '未ログインでusers/editを開いて、userログインして、users/editにリダイレクトされる' do
        visit edit_user_registration_path
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'passwordpassword'
        click_button 'Log in'
        expect(page).to have_current_path edit_user_registration_path
      end
    end

    context '認証情報が正しくない場合' do
      it 'ログインに失敗するとログイン画面のまま' do
        visit new_user_session_path
        fill_in 'メールアドレス', with: 'user@example.com'
        fill_in 'パスワード', with: 'machigattapassword'
        click_button 'Log in'
        expect(page).to have_current_path new_user_session_path
      end

      it 'ユーザーはログインしてからadmins_rootに行ってもログインを求められる' do
        login_as(user)
        visit admins_root_path
        expect(page).to have_current_path new_admin_session_path
      end
    end
  end
end
