class Admin < ActiveRecord::Base
  # used to replicate an active record object

  scope :active, -> { where(status: 'active') }

  serialize :roles, Array
end