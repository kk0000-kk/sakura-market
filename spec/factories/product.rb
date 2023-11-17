FactoryBot.define do
  factory :product do
    sequence(:name) { |n| "product-#{n}" }
    price { 1000 }
    description { '商品の説明' }
    disabled { false }
    sequence(:position) { |n| n }
  end
end
