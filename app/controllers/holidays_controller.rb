class HolidaysController < ApplicationController
  before_action :authenticate_user!
  layout "dashboard"

  def index
    redirect_to dashboard_path unless current_user.has_menu_access?('holidays')
    @holidays = Holiday.current_year.order(:date)
    @holiday = Holiday.new
  end

  def create
    redirect_to dashboard_path unless current_user.has_permission?('holiday_manage')
    @holiday = Holiday.new(holiday_params)
    if @holiday.save
      redirect_to holidays_path, notice: 'Holiday added successfully.'
    else
      @holidays = Holiday.current_year.order(:date)
      @show_modal = true
      render :index
    end
  end

  def destroy
    redirect_to dashboard_path unless current_user.has_permission?('holiday_manage')
    @holiday = Holiday.find(params[:id])
    @holiday.destroy
    redirect_to holidays_path, notice: 'Holiday deleted successfully.'
  end

  private

  def holiday_params
    params.require(:holiday).permit(:name, :date)
  end
end