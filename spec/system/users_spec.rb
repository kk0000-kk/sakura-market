require 'rails_helper'

RSpec.describe 'Users', type: :system do
  it 'ユーザーはログインすると、/homeにリダイレクトされる' do
    user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_current_path home_path
  end

  it '未ログインでusers/editを開いて、userログインして、users/editにリダイレクトされる' do
    user = FactoryBot.create(:user)
    visit edit_user_registration_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    expect(page).to have_current_path edit_user_registration_path
  end

  it 'ログインに失敗するとログイン画面のまま' do
    user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: 'machigattapassword'
    click_button 'Log in'
    expect(page).to have_current_path new_user_session_path
  end

  it 'ユーザーはログインしてからadmins_rootに行ってもログインを求められる' do
    user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'
    visit admins_root_path
    expect(page).to have_current_path new_admin_session_path
  end
end
