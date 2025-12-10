class Task < ApplicationRecord
  attr_accessor :updated_by_id

  belongs_to :project
  belongs_to :assigned_to, class_name: 'User', optional: true
  belongs_to :created_by, class_name: 'User'
  has_many :task_activities, dependent: :destroy

  enum priority: { low: 0, medium: 1, high: 2, urgent: 3 }
  enum status: { not_started: 0, in_progress: 1, completed: 2, on_hold: 3 }
  enum category: { development: 0, design: 1, bug_fix: 2, testing: 3 }

  validates :title, presence: true

  after_create :log_creation
  after_update :log_changes

  private

  def log_creation
    task_activities.create!(
      user: created_by,
      comment: "#{created_by.email.split('@').first} created the task on #{format_date(created_at)}"
    )
  end

  def log_changes
    if saved_change_to_assigned_to_id? && assigned_to.present?
      task_activities.create!(
        user: User.find(saved_changes['assigned_to_id'][1]),
        comment: "#{User.find_by(id: saved_changes['assigned_to_id'][1])&.email&.split('@')&.first || 'Someone'} was assigned to the task"
      )
    end

    if saved_change_to_status? && updated_by_id.present?
      old_status_value = saved_changes['status'][0]
      old_status = old_status_value.nil? ? 'not started' : Task.statuses.key(old_status_value)&.gsub('_', ' ') || 'unknown'
      new_status = status&.gsub('_', ' ') || 'not started'
      task_activities.create!(
        user: User.find_by(id: updated_by_id) || created_by,
        comment: "#{(User.find_by(id: updated_by_id) || created_by).email.split('@').first} modified the status to #{new_status}"
      )
    end
  end

  def format_date(date)
    date.strftime('%-d %b %Y')
  end
end
