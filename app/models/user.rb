class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { admin: 0, employee: 1 }
  enum gender: { male: 0, female: 1 }  # restrict to male/female only

  has_many :addresses, dependent: :destroy

  accepts_nested_attributes_for :addresses, allow_destroy: true

  def frozen_account?
    self.is_frozen
  end
end
