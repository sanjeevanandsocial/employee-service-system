module DateHelper
  def format_display_date(date)
    return '--' if date.nil?
    date.strftime('%d-%b-%Y')
  end
end
