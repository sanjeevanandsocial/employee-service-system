class TaskFilter < ApplicationRecord
  belongs_to :user
  serialize :filter_params, coder: JSON
  validates :name, presence: true
end
