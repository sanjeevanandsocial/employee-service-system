require 'csv'

class LeaveRequestsController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"

  def index
    @leave_requests = current_user.leave_requests.order(created_at: :desc)
    @leave_requests = @leave_requests.where("from_date <= ?", params[:to_date]) if params[:to_date].present?
    @leave_requests = @leave_requests.where("to_date >= ?", params[:from_date]) if params[:from_date].present?
    @leave_requests = @leave_requests.where(status: params[:status]) if params[:status].present?
    
    respond_to do |format|
      format.html { @leave_requests = @leave_requests.page(params[:page]).per(3) }
      format.csv { send_data generate_csv(@leave_requests), filename: "leave-requests-#{Date.today}.csv" }
    end
    
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = current_user.leave_requests.new(leave_request_params)
    @leave_request.reporting_person_id = current_user.reporting_person_id
    if @leave_request.save
      redirect_to leave_requests_path, notice: 'Leave request submitted successfully.'
    else
      @leave_requests = current_user.leave_requests.order(created_at: :desc).page(params[:page]).per(3)
      @show_modal = true
      render :index
    end
  end

  def cancel
    @leave_request = current_user.leave_requests.find(params[:id])
    if @leave_request.pending?
      @leave_request.update(status: 'cancelled')
      redirect_to leave_requests_path, notice: 'Leave request cancelled successfully.'
    else
      redirect_to leave_requests_path, alert: 'Only pending requests can be cancelled.'
    end
  end

  def approve_requests
    @leave_requests = LeaveRequest.joins(:user).where(users: { reporting_person_id: current_user.id }).order(created_at: :desc)
  end

  def update_status
    @leave_request = LeaveRequest.find(params[:id])
    if @leave_request.user.reporting_person_id == current_user.id
      @leave_request.update(status: params[:status])
      redirect_to approve_requests_leave_requests_path, notice: 'Request status updated.'
    else
      redirect_to approve_requests_leave_requests_path, alert: 'Unauthorized'
    end
  end

  private

  def leave_request_params
    params.require(:leave_request).permit(:from_date, :to_date, :reason)
  end

  def generate_csv(leave_requests)
    CSV.generate(headers: true) do |csv|
      csv << ["From Date", "To Date", "Reason", "Status", "Applied On"]
      leave_requests.each do |request|
        csv << [request.from_date.strftime('%-d %b %Y'), request.to_date.strftime('%-d %b %Y'), request.reason, request.status.titleize, request.created_at.strftime('%-d %b %Y')]
      end
    end
  end
end