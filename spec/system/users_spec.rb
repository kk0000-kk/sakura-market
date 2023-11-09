require 'rails_helper'

RSpec.describe 'Users', type: :system do
  describe 'ユーザーログイン' do
    before do
      create(:user, email: 'user@example.com', password: 'passwordpassword', password_confirmation: 'passwordpassword')
    end

    context '認証情報が正しい場合' do
      it 'ユーザーはログインすると、/homeにリダイレクトされる' do
        visit new_user_session_path
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'passwordpassword'
        click_button 'Log in'
        expect(page).to have_current_path home_path
      end

      it '未ログインでusers/editを開いて、userログインして、users/editにリダイレクトされる' do
        visit edit_user_registration_path
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'passwordpassword'
        click_button 'Log in'
        expect(page).to have_current_path edit_user_registration_path
      end
    end

    context '認証情報が正しくない場合' do
      it 'ログインに失敗するとログイン画面のまま' do
        visit new_user_session_path
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'machigattapassword'
        click_button 'Log in'
        expect(page).to have_current_path new_user_session_path
      end

      it 'ユーザーはログインしてからadmins_rootに行ってもログインを求められる' do
        visit new_user_session_path
        fill_in 'Email', with: 'user@example.com'
        fill_in 'Password', with: 'passwordpassword'
        click_button 'Log in'
        visit admins_root_path
        expect(page).to have_current_path new_admin_session_path
      end
    end
  end
end
