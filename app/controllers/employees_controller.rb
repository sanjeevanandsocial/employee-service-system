require 'csv'

class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin, except: [:index, :attendance, :new, :create, :edit, :update]
  before_action :set_employee, only: [:edit, :update]
  layout "dashboard"

  def index
    redirect_to dashboard_path unless current_user.has_menu_access?('employees')
    
    @employees = case current_user.get_permission('employee_view')
                 when 'all'
                   User.all
                 when 'assigned'
                   User.where(reporting_person: current_user)
                 else
                   User.none
                 end
    
    @employees = @employees.where(id: params[:id]) if params[:id].present?
    @employees = @employees.where("email LIKE ?", "%#{params[:email]}%") if params[:email].present?
    @employees = @employees.where(role: params[:role]) if params[:role].present?
    @employees = @employees.where(is_frozen: params[:status] == "frozen") if params[:status].present?
    
    respond_to do |format|
      format.html { @employees = @employees.page(params[:page]).per(3) }
      format.csv { send_data generate_csv(@employees), filename: "employees-#{Date.today}.csv" }
    end
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
      render :new, status: :unprocessable_entity
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
    params.require(:user).permit(:email, :password, :password_confirmation, :role, :gender, :age, :reporting_person_id, addresses_attributes: [:id, :address_type, :line1, :line2, :city, :state, :zip, :country])
  end

  def generate_csv(employees)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Email", "Role", "Gender", "Age", "Status", "Created At"]
      employees.each do |emp|
        csv << [emp.id, emp.email, emp.role.capitalize, emp.gender.capitalize, emp.age, emp.is_frozen ? "Frozen" : "Active", emp.created_at.strftime("%Y-%m-%d")]
      end
    end
  end
end
