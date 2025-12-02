class Address < ApplicationRecord
  belongs_to :user

  enum address_type: { current: "current", permanent: "permanent" }
end
