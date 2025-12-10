require 'csv'

class TasksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_project, except: [:index]
  layout "dashboard"

  def index
    redirect_to dashboard_path unless current_user.has_menu_access?('tasks')
    redirect_to dashboard_path unless current_user.has_permission?('task_search')
    @task_filters = current_user.task_filters
    @projects = Project.all
    
    @has_filters = params[:id].present? || params[:title].present? || params[:project_id].present? || params[:priority].present? || params[:status].present? || params[:assigned_to_id].present? || params[:category].present? || params[:due_date].present? || params[:filter_id].present?
    
    if params[:filter_id].present?
      filter = current_user.task_filters.find(params[:filter_id])
      filter_params = JSON.parse(filter.filter_params)
      params.merge!(filter_params)
    end
    
    if @has_filters
      @tasks = Task.includes(:project, :assigned_to).order(created_at: :desc)
      @tasks = @tasks.where(id: params[:id]) if params[:id].present?
      @tasks = @tasks.where("title LIKE ?", "%#{params[:title]}%") if params[:title].present?
      @tasks = @tasks.where(project_id: params[:project_id]) if params[:project_id].present?
      @tasks = @tasks.where(priority: params[:priority]) if params[:priority].present?
      @tasks = @tasks.where(status: params[:status]) if params[:status].present?
      @tasks = @tasks.where(assigned_to_id: params[:assigned_to_id]) if params[:assigned_to_id].present?
      @tasks = @tasks.where(category: params[:category]) if params[:category].present?
      @tasks = @tasks.where(due_date: params[:due_date]) if params[:due_date].present?
      
      respond_to do |format|
        format.html { @tasks = @tasks.page(params[:page]).per(3) }
        format.csv { send_data generate_csv(@tasks), filename: "tasks-#{Date.today}.csv" }
      end
    else
      @tasks = Task.none.page(params[:page]).per(3)
    end
  end

  def new
    @task = @project.tasks.new
  end

  def create
    @task = @project.tasks.new(task_params)
    @task.created_by = current_user
    
    if @task.save
      if params[:from_tasks_index]
        redirect_to tasks_path, notice: 'Task created successfully.'
      else
        redirect_to details_project_path(@project, anchor: 'tasks-tab'), notice: 'Task created successfully.'
      end
    else
      render :new
    end
  end

  def edit
    @task = @project.tasks.find(params[:id])
  end

  def update
    @task = @project.tasks.find(params[:id])
    @task.updated_by_id = current_user.id
    
    comment_text = params.dig(:task, :comment)
    
    if comment_text.present?
      @task.task_activities.create!(
        user: current_user,
        comment: comment_text
      )
      redirect_to tasks_path, notice: 'Comment added successfully.'
    elsif params[:task].present? && @task.update(task_params.except(:comment))
      if params[:from_tasks_index]
        redirect_to tasks_path, notice: 'Task updated successfully.'
      else
        redirect_to details_project_path(@project, anchor: 'tasks-tab'), notice: 'Task updated successfully.'
      end
    else
      render :edit
    end
  end

  def destroy
    redirect_to dashboard_path unless current_user.has_permission?('task_delete')
    @task = @project.tasks.find(params[:id])
    @task.destroy
    if request.referer&.include?('tasks')
      redirect_to tasks_path, notice: 'Task deleted successfully.'
    else
      redirect_to details_project_path(@project, anchor: 'tasks-tab'), notice: 'Task deleted successfully.'
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def task_params
    params.require(:task).permit(:title, :description, :priority, :due_date, :status, :assigned_to_id, :category, :estimated_time, :comment)
  end

  def generate_csv(tasks)
    CSV.generate(headers: true) do |csv|
      csv << ["ID", "Title", "Project", "Priority", "Status", "Assigned To", "Category", "Due Date", "Created At"]
      tasks.each do |task|
        csv << [task.id, task.title, task.project.title, task.priority.titleize, task.status.gsub('_', ' ').titleize, task.assigned_to&.email || '--', task.category.gsub('_', ' ').titleize, task.due_date, task.created_at.strftime("%Y-%m-%d")]
      end
    end
  end
end
