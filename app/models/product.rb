class Product < ApplicationRecord
  has_one_attached :image
  validates :name, presence: true
  validates :price, presence: true
  validates :position, presence: true
end
