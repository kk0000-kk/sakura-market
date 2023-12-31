# frozen_string_literal: true

30.times do |n|
  email = "admin-#{n + 1}@example.com"
  password = 'passwordpassword'
  Admin.create!(email:,
               password:,
               password_confirmation: password)
end


100.times do |n|
  email = "user-#{n + 1}@example.com"
  nick_name = "ニック-#{n + 1}"
  password = 'passwordpassword'
  User.create!(email:,
               nick_name:,
               password:,
               password_confirmation: password)
end

100.times do |n|
  name= "商品-#{n + 1}"
  price = rand(1000..10000)
  description = "商品-#{n + 1}の説明文です。"
  disabled = [true, false].sample
  position = n + 1
  Product.create!(name:, price:, description:, disabled:, position:)
end
