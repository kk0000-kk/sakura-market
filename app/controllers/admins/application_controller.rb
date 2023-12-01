# frozen_string_literal: true

class Admins::ApplicationController < ApplicationController
  before_action :authenticate_admin!
  skip_before_action :authenticate_user!

  layout 'admins/application'
end
