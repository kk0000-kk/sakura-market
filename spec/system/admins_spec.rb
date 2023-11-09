require 'rails_helper'

RSpec.describe 'Admins', type: :system do
  it '管理者はログインすると、admins_rootにリダイレクトされる' do
    admin = FactoryBot.create(:admin)
    visit admins_root_path
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: admin.password
    click_button 'Log in'
    expect(page).to have_current_path admins_root_path
  end

  it 'ログインに失敗するとログイン画面のまま' do
    admin = FactoryBot.create(:admin)
    visit admins_root_path
    fill_in 'Email', with: admin.email
    fill_in 'Password', with: 'machigattapassword'
    click_button 'Log in'
    expect(page).to have_current_path new_admin_session_path
  end
end
