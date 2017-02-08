class Admin < ActiveRecord::Base
  # used to replicate an active record object

  scope :active, -> { where(status: 'active') }

  serialize :roles, Array

  def root_url
    "path/to/root"
  end

  def org_status
    "active"
  end
end