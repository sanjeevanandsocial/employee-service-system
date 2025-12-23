class PasswordResetController < ApplicationController
  skip_before_action :authenticate_user!
  before_action :find_user_by_email, only: [:send_code, :verify_code, :reset_password]
  before_action :validate_reset_token, only: [:verify_code, :reset_password]

  def forgot_password
  end

  def send_code
    @user = User.find_by(email: params[:email])
    
    if @user
      if can_send_code?
        @user.generate_reset_token
        email_service = BrevoEmailService.new
        
        if email_service.send_reset_code(@user.email, @user.reset_token, @user.masked_email)
          session[:reset_email] = @user.email
          redirect_to verify_code_path, notice: "A verification code has been sent to #{@user.masked_email}."
        else
          redirect_to forgot_password_path, alert: "Failed to send verification code. Please try again."
        end
      else
        redirect_to forgot_password_path, alert: "Please wait before requesting another code."
      end
    else
      redirect_to forgot_password_path, alert: "Email address not found."
    end
  end

  def verify_code
    redirect_to forgot_password_path, alert: "Session expired." unless session[:reset_email]
  end

  def validate_code
    @user = User.find_by(email: session[:reset_email])
    
    if @user && @user.reset_token_valid?
      if @user.can_attempt_reset?
        if @user.reset_token == params[:code]
          session[:reset_verified] = true
          redirect_to reset_password_path
        else
          @user.increment_reset_attempts
          redirect_to verify_code_path, alert: "Invalid verification code. Please try again."
        end
      else
        @user.clear_reset_token
        session.delete(:reset_email)
        redirect_to forgot_password_path, alert: "Too many attempts. Please request a new code."
      end
    else
      redirect_to forgot_password_path, alert: "Invalid session. Please request a new code."
    end
  end

  def reset_password
    redirect_to forgot_password_path, alert: "Unauthorized access." unless session[:reset_verified]
  end

  def update_password
    @user = User.find_by(email: session[:reset_email])
    
    if @user && session[:reset_verified]
      if params[:password] == params[:password_confirmation]
        if @user.update(password: params[:password], password_confirmation: params[:password_confirmation])
          @user.clear_reset_token
          session.delete(:reset_email)
          session.delete(:reset_verified)
          redirect_to new_user_session_path, notice: "Your password has been changed successfully. Please log in."
        else
          redirect_to reset_password_path, alert: @user.errors.full_messages.join(', ')
        end
      else
        redirect_to reset_password_path, alert: "Password and confirmation do not match."
      end
    else
      redirect_to forgot_password_path, alert: "Unauthorized access."
    end
  end

  def resend_code
    @user = User.find_by(email: session[:reset_email])
    
    if @user && can_send_code?
      @user.generate_reset_token
      email_service = BrevoEmailService.new
      
      if email_service.send_reset_code(@user.email, @user.reset_token, @user.masked_email)
        redirect_to verify_code_path, notice: "A new verification code has been sent to #{@user.masked_email}."
      else
        redirect_to verify_code_path, alert: "Failed to send verification code. Please try again."
      end
    else
      redirect_to verify_code_path, alert: "Please wait before requesting another code."
    end
  end

  private

  def find_user_by_email
    @user = User.find_by(email: params[:email] || session[:reset_email])
  end

  def validate_reset_token
    redirect_to forgot_password_path, alert: "Session expired." unless @user&.reset_token_valid?
  end

  def can_send_code?
    return true unless @user.reset_token_sent_at
    @user.reset_token_sent_at < 1.minute.ago
  end
end