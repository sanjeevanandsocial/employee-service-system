require 'csv'

class ProjectsController < ApplicationController
    before_action :authenticate_user!
    layout "dashboard"
    def index
        redirect_to dashboard_path unless current_user.has_menu_access?('projects')
        
        @projects = case current_user.get_permission('project_view')
                    when 'all'
                      Project.all
                    when 'assigned'
                      current_user.projects
                    else
                      Project.none
                    end
        
        @projects = @projects.order(created_at: :desc)
        @projects = @projects.where(id: params[:id]) if params[:id].present?
        @projects = @projects.where("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
        @projects = @projects.where(status: params[:status]) if params[:status].present?
        
        respond_to do |format|
          format.html { @projects = @projects.page(params[:page]).per(3) }
          format.csv { send_data generate_csv(@projects), filename: "projects-#{Date.today}.csv" }
        end
    end

    def new
        redirect_to dashboard_path unless current_user.has_permission?('project_create')
        @project = Project.new
    end

    def create
        @project = Project.new(project_params)
        @project.status = "planned"
        if @project.save
          redirect_to projects_path, notice: "Project created successfully!"
        else
          render :new, status: :unprocessable_entity
        end
    end

    def edit
        redirect_to dashboard_path unless current_user.has_permission?('project_modify')
        @project = Project.find(params[:id])
    end

    def update
        @project = Project.find(params[:id])
        old_status = @project.status
        new_status = project_params[:status]
        
        if new_status == "in_progress" && old_status == "planned"
          @project.start_date = Date.today
        end
        
        if new_status == "completed" || new_status == "cancelled"
          @project.end_date = Date.today
        end
        
        if @project.update(project_params)
          redirect_to projects_path, notice: "Project updated successfully!"
        else
          render :edit, status: :unprocessable_entity
        end
    end

    def details
        redirect_to dashboard_path unless current_user.has_permission?('project_modify_employees')
        @project = Project.find(params[:id])
    end

    private
    def project_params
        params.require(:project).permit(:title, :description, :start_date, :end_date, :status)
    end



    def generate_csv(projects)
        CSV.generate(headers: true) do |csv|
          csv << ["ID", "Title", "Description", "Status", "Start Date", "End Date", "Created At"]
          projects.each do |project|
            csv << [project.id, project.title, project.description, project.status.gsub('_', ' ').titleize, project.start_date, project.end_date, project.created_at.strftime("%Y-%m-%d")]
          end
        end
    end

end
