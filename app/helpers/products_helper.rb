module ProductsHelper
  def product_image(product, variant, size)
    image_tag product.image.attached? ? product.image.variant(variant) : 'no_image.png', size:
  end
end
