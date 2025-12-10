class AccessControlController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin
  layout "dashboard"

  def index
  end

  def search
    employee_id = params[:employee_id]
    employee_email = params[:employee_email]
    
    @employee = nil
    if employee_id.present?
      @employee = User.find_by(id: employee_id)
    elsif employee_email.present?
      @employee = User.find_by(email: employee_email)
    end
    
    if @employee
      permissions = @employee.user_permissions.pluck(:permission_key, :permission_value).to_h
      render json: {
        found: true,
        employee: {
          id: @employee.id,
          email: @employee.email,
          role: @employee.role
        },
        permissions: permissions
      }
    else
      render json: { found: false }
    end
  end

  def update_permissions
    employee_id = params[:employee_id]
    permissions = params[:permissions] || {}
    
    @employee = User.find_by(id: employee_id)
    return render json: { success: false, message: 'Employee not found' } unless @employee
    
    UserPermission.where(user: @employee).destroy_all
    
    permissions.each do |key, value|
      @employee.user_permissions.create!(permission_key: key, permission_value: value)
    end
    
    render json: { success: true, message: 'Permissions updated successfully' }
  end

  private

  def ensure_admin
    redirect_to dashboard_path unless current_user.role == 'admin'
  end
end