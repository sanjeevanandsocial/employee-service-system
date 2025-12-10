class UserPermission < ApplicationRecord
  belongs_to :user

  validates :permission_key, presence: true
  validates :permission_value, presence: true
end