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

  def change_password
    @user = current_user
    flash.delete(:notice)
  end

  def update_password
    @user = current_user
    
    if @user.valid_password?(params[:current_password])
      if params[:password] == params[:current_password]
        redirect_to change_password_path, alert: 'New password cannot be the same as current password.'
      elsif params[:password] == params[:password_confirmation]
        if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
          redirect_to change_password_path, notice: 'Password updated successfully!'
        else
          redirect_to change_password_path, alert: @user.errors.full_messages.join(', ')
        end
      else
        redirect_to change_password_path, alert: 'New password and confirmation do not match.'
      end
    else
      redirect_to change_password_path, alert: 'Current password is incorrect.'
    end
  end
end