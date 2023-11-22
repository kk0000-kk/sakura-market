# frozen_string_literal: true

class ApplicationController < ActionController::Base
  def current_cart
    if user_signed_in?
      current_user.cart || current_user.create_cart!
    end
  end
end
