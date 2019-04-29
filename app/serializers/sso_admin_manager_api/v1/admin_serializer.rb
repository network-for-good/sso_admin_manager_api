module SsoAdminManagerApi
  module V1
    # Serializes an admin AR object
    # 4/29/2019 - In order to allow for the consuming
    # apps to catch up to the interface for this serializer
    # we are allowing for them not to have an org or org_id value
    # in the Admin model

    # In the future, we can remove this check, once all consuming
    # apps have both an org and and org_id attribute.
    class AdminSerializer < ActiveModel::Serializer
      attributes  :id, :first_name, :last_name, :email, :status,
                  :roles, :root_url, :org_status, :org_identifier, :app, :org_id

      def org_id
        if object.respond_to?(:org_id)
          object.org_id
        else
          org.try(:id)
        end
      end

      def org
        object.respond_to?(:org) ? object.org : nil
      end
    end
  end
end
