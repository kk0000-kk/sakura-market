# frozen_string_literal: true

class Admins::ApplicationController < ApplicationController
  before_action :authenticate_admin!
  layout 'admins/application'
end
