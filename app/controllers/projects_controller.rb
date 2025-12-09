class ProjectsController < ApplicationController
    before_action :authenticate_user!
    before_action :check_admin
    layout "dashboard"
    def index
        @projects = Project.all.order(created_at: :desc)
    end

    def new
        @project = Project.new
    end

    def create
        @project = Project.new(project_params)
        if @project.save
          redirect_to projects_path, notice: "Project created successfully!"
        else
          render :new, status: :unprocessable_entity
        end
    end

    def edit
        @project = Project.find(params[:id])
    end

    def update
        @project = Project.find(params[:id])
        if @project.update(project_params)
          redirect_to projects_path, notice: "Project updated successfully!"
        else
          render :edit, status: :unprocessable_entity
        end
    end

    def details
        @project = Project.find(params[:id])
    end

    private
    def project_params
        params.require(:project).permit(:title, :description, :start_date, :end_date, :status)
    end

    def check_admin
        redirect_to root_path, alert: "Unauthorized" unless current_user.admin?
    end

end
