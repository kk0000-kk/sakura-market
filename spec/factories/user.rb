FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "user-#{n}@example.com" }
    nick_name { 'ニック・ネーム' }
    password { 'passwordpassword' }
    password_confirmation { 'passwordpassword' }
  end
end
