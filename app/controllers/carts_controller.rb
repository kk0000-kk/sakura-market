class CartsController < ApplicationController
  before_action :set_cart, only: :show
  before_action :authenticate_user!, only: :show

  def show
  end

  private

  def set_cart
    @cart = current_cart
  end
end
