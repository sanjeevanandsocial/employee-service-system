class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 0, employee: 1 }
  enum gender: { male: 0, female: 1 }  # restrict to male/female only

  has_many :addresses, dependent: :destroy
  has_many :project_employees, dependent: :destroy
  has_many :projects, through: :project_employees
  has_many :task_filters, dependent: :destroy
  has_many :od_requests, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :user_permissions, dependent: :destroy
  belongs_to :reporting_person, class_name: 'User', optional: true
  has_one_attached :profile_picture

  accepts_nested_attributes_for :addresses, allow_destroy: true

  validates :gender, presence: true
  validates :age, presence: true, numericality: { only_integer: true, greater_than: 0 }

  def frozen_account?
    self.is_frozen
  end

  def has_permission?(key)
    return true if admin?
    user_permissions.exists?(permission_key: key, permission_value: 'true')
  end

  def get_permission(key)
    return 'all' if admin?
    user_permissions.find_by(permission_key: key)&.permission_value
  end

  def has_menu_access?(menu)
    return true if admin?
    case menu
    when 'employees'
      get_permission('employee_view').present? || has_permission?('employee_create') || has_permission?('employee_edit')
    when 'projects'
      get_permission('project_view').present? || has_permission?('project_create') || has_permission?('project_modify') || has_permission?('project_modify_employees')
    when 'tasks'
      has_permission?('tasks_menu')
    when 'holidays'
      has_permission?('holiday_view') || has_permission?('holiday_manage')
    when 'approve_requests'
      has_permission?('request_approve')
    else
      false
    end
  end

  def generate_reset_token
    self.reset_token = rand(1000..9999).to_s
    self.reset_token_expires_at = nil
    self.reset_token_sent_at = Time.current
    self.reset_attempts = 0
    save!
  end

  def reset_token_valid?
    true
  end

  def increment_reset_attempts
    self.reset_attempts += 1
    save!
  end

  def can_attempt_reset?
    reset_attempts < 3
  end

  def clear_reset_token
    self.reset_token = nil
    self.reset_token_expires_at = nil
    self.reset_attempts = 0
    self.reset_token_sent_at = nil
    save!
  end

  def masked_email
    email_parts = email.split('@')
    username = email_parts[0]
    domain = email_parts[1]
    masked_username = username[0] + '*' * (username.length - 2) + username[-1] if username.length > 2
    masked_username ||= username[0] + '*' if username.length == 2
    masked_username ||= '*' if username.length == 1
    "#{masked_username}@#{domain}"
  end
end
