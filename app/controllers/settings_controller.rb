class SettingsController < ApplicationController
  before_action :authenticate_user!
  layout 'dashboard'

  def change_profile_picture
    @user = current_user
  end

  def update_profile_picture
    @user = current_user
    
    if params[:profile_picture].present?
      @user.profile_picture.attach(params[:profile_picture])
      redirect_to change_profile_picture_path, notice: 'Profile picture updated successfully!'
    else
      redirect_to change_profile_picture_path, alert: 'Please select an image to upload.'
    end
  end
end