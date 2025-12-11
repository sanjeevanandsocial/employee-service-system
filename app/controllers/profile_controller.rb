class ProfileController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"

  def show
    @user = current_user
  end
end