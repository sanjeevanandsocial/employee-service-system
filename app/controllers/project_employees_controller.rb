class ProjectEmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_admin
  before_action :set_project

  def create
    @project_employee = @project.project_employees.build(user_id: params[:user_id])
    
    if @project_employee.save
      redirect_to details_project_path(@project), notice: "Employee added successfully!"
    else
      redirect_to details_project_path(@project), alert: "Failed to add employee."
    end
  end

  def destroy
    @project_employee = @project.project_employees.find(params[:id])
    @project_employee.destroy
    redirect_to details_project_path(@project), notice: "Employee removed successfully!"
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def check_admin
    redirect_to root_path, alert: "Unauthorized" unless current_user.admin?
  end
end
