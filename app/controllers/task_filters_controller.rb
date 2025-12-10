class TaskFiltersController < ApplicationController
  before_action :authenticate_user!

  def create
    @task_filter = current_user.task_filters.new(task_filter_params)
    if @task_filter.save
      redirect_to tasks_path, notice: 'Filter bookmarked successfully.'
    else
      redirect_to tasks_path, alert: 'Failed to bookmark filter.'
    end
  end

  def destroy
    @task_filter = current_user.task_filters.find(params[:id])
    @task_filter.destroy
    redirect_to tasks_path, notice: 'Filter bookmark removed.'
  end

  private

  def task_filter_params
    params.require(:task_filter).permit(:name, :filter_params)
  end
end
