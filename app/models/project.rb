class Project < ApplicationRecord
    
    enum status: { planned: 'planned', in_progress: 'in_progress', on_hold: 'on_hold', completed: 'completed', cancelled: 'cancelled' }

    has_many :project_employees, dependent: :destroy
    has_many :users, through: :project_employees
    has_many :tasks, dependent: :destroy

    validates :status, inclusion: { in: statuses.keys }
end
