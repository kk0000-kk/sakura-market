module ProductsHelper
  def product_image(product, size)
    image_tag product.image.attached? ? product.image.variant(:thumbnail) : 'no_image.png', size:
  end
end
