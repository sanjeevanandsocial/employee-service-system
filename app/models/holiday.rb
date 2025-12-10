class Holiday < ApplicationRecord
  validates :name, :date, presence: true
  validates :date, uniqueness: { message: "already has a holiday" }
  validate :date_must_be_current_year

  before_save :capitalize_name

  scope :current_year, -> { where(date: Date.current.beginning_of_year..Date.current.end_of_year) }

  private

  def capitalize_name
    self.name = name.strip.capitalize if name.present?
  end

  def date_must_be_current_year
    return if date.blank?
    unless date.year == Date.current.year
      errors.add(:date, "must be in the current year (#{Date.current.year})")
    end
  end
end