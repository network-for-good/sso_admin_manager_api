module SsoAuthenticationApi::V1
  class AdminSerializer < ActiveModel::Serializer
    attributes :id, :first_name, :last_name, :email, :status, :roles
  end
end