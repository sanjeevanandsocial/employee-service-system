class Project < ApplicationRecord
    
    enum status: { planned: 'planned', in_progress: 'in-progress', on_hold: 'on-hold', completed: 'completed' }

    validates :status, inclusion: { in: statuses.keys }
end
