class LeaveRequest < ApplicationRecord
  belongs_to :user
  belongs_to :reporting_person, class_name: 'User', optional: true

  enum status: { pending: 0, approved: 1, rejected: 2, cancelled: 3 }

  validates :from_date, :to_date, :reason, presence: true
  validate :to_date_after_from_date
  validate :no_overlapping_requests
  validate :no_overlapping_od_requests
  validate :reporting_person_assigned

  def total_days
    return 0 if from_date.blank? || to_date.blank?
    (to_date - from_date).to_i + 1
  end

  private

  def to_date_after_from_date
    return if to_date.blank? || from_date.blank?
    errors.add(:to_date, "must be same as or after from date") if to_date < from_date
  end

  def no_overlapping_requests
    return if from_date.blank? || to_date.blank? || user.blank?
    
    overlapping = user.leave_requests.where.not(id: id).where.not(status: 'cancelled')
                     .where("(from_date <= ? AND to_date >= ?) OR (from_date <= ? AND to_date >= ?) OR (from_date >= ? AND to_date <= ?)",
                            from_date, from_date, to_date, to_date, from_date, to_date)
    
    if overlapping.exists?
      overlapping_request = overlapping.first
      if overlapping_request.from_date == overlapping_request.to_date
        errors.add(:base, "You already have a leave request for #{overlapping_request.from_date.strftime('%-d %b %Y')}")
      else
        errors.add(:base, "You already have a leave request from #{overlapping_request.from_date.strftime('%-d %b %Y')} to #{overlapping_request.to_date.strftime('%-d %b %Y')}")
      end
    end
  end

  def no_overlapping_od_requests
    return if from_date.blank? || to_date.blank? || user.blank?
    
    overlapping = user.od_requests.where.not(status: 'cancelled')
                     .where("(from_date <= ? AND to_date >= ?) OR (from_date <= ? AND to_date >= ?) OR (from_date >= ? AND to_date <= ?)",
                            from_date, from_date, to_date, to_date, from_date, to_date)
    
    if overlapping.exists?
      overlapping_request = overlapping.first
      if overlapping_request.from_date == overlapping_request.to_date
        errors.add(:base, "You already have an OD request for #{overlapping_request.from_date.strftime('%-d %b %Y')}")
      else
        errors.add(:base, "You already have an OD request from #{overlapping_request.from_date.strftime('%-d %b %Y')} to #{overlapping_request.to_date.strftime('%-d %b %Y')}")
      end
    end
  end

  def reporting_person_assigned
    return if user.blank?
    errors.add(:base, "No reporting person assigned to you") if user.reporting_person_id.blank?
  end
end