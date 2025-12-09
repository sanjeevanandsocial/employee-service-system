class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_employee, only: [:edit, :update]
  layout "dashboard"

  def index
    @employees = User.all
    @employees = @employees.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
    @employees = @employees.where(role: params[:role]) if params[:role].present?
    @employees = @employees.where(is_frozen: params[:status] == "frozen") if params[:status].present?
    @employees = @employees.page(params[:page]).per(3)
  end

  def new
    @employee = User.new
    @employee.addresses.build(address_type: :current)
  end

  def create
    @employee = User.new(employee_params)
    @employee.role = :employee

    if @employee.save
      redirect_to employees_path, notice: "Employee created successfully."
    else
      @employee.addresses.build(address_type: :current) if @employee.addresses.empty?
      render :new
    end
  end

  def edit
    @employee.addresses.build(address_type: :current) if @employee.addresses.empty?
  end

  def update
    if @employee.update(employee_params)
      redirect_to employees_path, notice: "Employee updated successfully."
    else
      render :edit
    end
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
    params.require(:user).permit(:role, :age, addresses_attributes: [:id, :line1, :line2, :city, :state, :zip, :country])
  end
end
