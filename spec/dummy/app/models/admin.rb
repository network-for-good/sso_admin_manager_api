class Admin < ActiveRecord::Base
  # used to replicate an active record object

  scope :active, -> { where(status: 'active') }

  serialize :roles, type: Array

  serialize :product_names, type: Array

  def root_url
    "path/to/root"
  end

  def org_status
    "active"
  end

  def org_identifier
    "nfg"
  end

  def app
    "dummy"
  end
end