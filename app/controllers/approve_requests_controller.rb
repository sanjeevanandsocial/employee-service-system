class ApproveRequestsController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"

  def index
    redirect_to dashboard_path unless current_user.has_menu_access?('approve_requests')
    @request_type = params[:type] || 'od'
    
    @pending_od_count = OdRequest.joins(:user).where(users: { reporting_person_id: current_user.id }, status: 'pending').count
    @pending_leave_count = LeaveRequest.joins(:user).where(users: { reporting_person_id: current_user.id }, status: 'pending').count
    
    if @request_type == 'leave'
      @requests = LeaveRequest.joins(:user).where(users: { reporting_person_id: current_user.id }).order(created_at: :desc)
    else
      @requests = OdRequest.joins(:user).where(users: { reporting_person_id: current_user.id }).order(created_at: :desc)
    end
  end

  def update_od_status
    @od_request = OdRequest.find(params[:id])
    if @od_request.user.reporting_person_id == current_user.id
      @od_request.update(status: params[:status])
      redirect_to approve_requests_path, notice: 'OD request status updated.'
    else
      redirect_to approve_requests_path, alert: 'Unauthorized'
    end
  end

  def update_leave_status
    @leave_request = LeaveRequest.find(params[:id])
    if @leave_request.user.reporting_person_id == current_user.id
      @leave_request.update(status: params[:status])
      redirect_to approve_requests_path, notice: 'Leave request status updated.'
    else
      redirect_to approve_requests_path, alert: 'Unauthorized'
    end
  end
end