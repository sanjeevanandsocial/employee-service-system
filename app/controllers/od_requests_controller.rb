require 'csv'

class OdRequestsController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"

  def index
    @od_requests = current_user.od_requests.order(created_at: :desc)
    @od_requests = @od_requests.where("from_date <= ?", params[:to_date]) if params[:to_date].present?
    @od_requests = @od_requests.where("to_date >= ?", params[:from_date]) if params[:from_date].present?
    @od_requests = @od_requests.where(status: params[:status]) if params[:status].present?
    
    respond_to do |format|
      format.html { @od_requests = @od_requests.page(params[:page]).per(3) }
      format.csv { send_data generate_csv(@od_requests), filename: "od-requests-#{Date.today}.csv" }
    end
    
    @od_request = OdRequest.new
  end

  def create
    @od_request = current_user.od_requests.new(od_request_params)
    @od_request.reporting_person_id = current_user.reporting_person_id
    if @od_request.save
      redirect_to od_requests_path, notice: 'OD request submitted successfully.'
    else
      @od_requests = current_user.od_requests.order(created_at: :desc).page(params[:page]).per(3)
      @show_modal = true
      render :index
    end
  end

  def cancel
    @od_request = current_user.od_requests.find(params[:id])
    if @od_request.pending?
      @od_request.update(status: 'cancelled')
      redirect_to od_requests_path, notice: 'OD request cancelled successfully.'
    else
      redirect_to od_requests_path, alert: 'Only pending requests can be cancelled.'
    end
  end

  def approve_requests
    @od_requests = OdRequest.joins(:user).where(users: { reporting_person_id: current_user.id }).order(created_at: :desc)
  end

  def update_status
    @od_request = OdRequest.find(params[:id])
    if @od_request.user.reporting_person_id == current_user.id
      @od_request.update(status: params[:status])
      redirect_to approve_requests_od_requests_path, notice: 'Request status updated.'
    else
      redirect_to approve_requests_od_requests_path, alert: 'Unauthorized'
    end
  end

  private

  def od_request_params
    params.require(:od_request).permit(:from_date, :to_date, :reason)
  end

  def generate_csv(od_requests)
    CSV.generate(headers: true) do |csv|
      csv << ["From Date", "To Date", "Reason", "Status", "Applied On"]
      od_requests.each do |request|
        csv << [request.from_date.strftime('%-d %b %Y'), request.to_date.strftime('%-d %b %Y'), request.reason, request.status.titleize, request.created_at.strftime('%-d %b %Y')]
      end
    end
  end
end
