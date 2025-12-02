class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_employee, only: [:edit, :update, :freeze_account]
  layout "dashboard"

  def index
    @employees = User.all
  end

  def new
    @employee = User.new

    # Build current & permanent addresses
    @employee.addresses.build(address_type: :current)
    @employee.addresses.build(address_type: :permanent)
  end

  def create
    @employee = User.new(employee_params)
    @employee.role = :employee

    if @employee.save
      redirect_to employees_path, notice: "Employee created successfully."
    else
      render :new
    end
  end

  def edit
    # Ensure BOTH addresses exist when editing
    if @employee.addresses.current.blank?
      @employee.addresses.build(address_type: :current)
    end

    if @employee.addresses.permanent.blank?
      @employee.addresses.build(address_type: :permanent)
    end
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_path, notice: "Employee updated successfully."
    else
      render :edit
    end
  end

  def freeze_account
    @employee.update(is_frozen: true)
    redirect_to employees_path, notice: "Employee account frozen."
  end

  def attendance
    @employee = User.find(params[:id])
    @date = params[:month] ? Date.parse(params[:month]) : Date.today
    @start_date = @date.beginning_of_month
    @end_date = @date.end_of_month
  end

  private

  def set_employee
    @employee = User.find(params[:id])
  end

  def check_admin
    redirect_to root_path, alert: "Unauthorized" unless current_user.admin?
  end

  def employee_params
    params.require(:user).permit(
      :email, :password, :password_confirmation, :role, :gender, :age,
      addresses_attributes: [:id, :address_type, :line1, :line2, :city, :state, :zip, :country, :_destroy]
    )
  end
end
