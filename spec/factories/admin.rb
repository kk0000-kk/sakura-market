FactoryBot.define do
  factory :admin do
    sequence(:email) { |n| "admin-#{n}@example.com" }
    password { 'passwordpassword' }
    password_confirmation { 'passwordpassword' }
  end
end
