module SsoAdminManagerApi::V1
  class AdminSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email, :status, :roles, :root_url, :org_status, :org_identifier, :app
  end
end