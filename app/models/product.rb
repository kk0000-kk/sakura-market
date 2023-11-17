class Product < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :display, resize_to_limit: [500, 500]
  end
  validates :name, presence: true
  validates :price, presence: true
  validates :position, presence: true
  acts_as_list
end
