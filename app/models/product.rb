class Product < ApplicationRecord
  has_one_attached :image do |attachable|
    attachable.variant :page_display, resize_to_limit: [500, 500]
    attachable.variant :thumbnail, resize_to_limit: [64, 64]
  end
  has_one :cart_item, dependent: :destroy

  validates :name, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :position, presence: true

  acts_as_list

  scope :purchasable, -> { where(disabled: false) }

  def price_with_tax
    (price * 1.1).floor
  end
end
