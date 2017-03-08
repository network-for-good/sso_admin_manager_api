require 'sso_admin_manager_api/secure_api'

module SsoAdminManagerApi
  module V1
    class AdminsController < ActionController::Base
      include SsoAdminManagerApi::TokenAuthentication
      respond_to :json

      before_filter :authorize_nfg_request!

      def index
        load_admins

        if @admins.present?
          render json: @admins, adapter: :json_api, key_transform: :underscore, meta: { record_count: @admins.length }
        else
          render(json: { errors: "Admin could not be found"}, status: 404)
        end

      # rescue StandardError => e
      #   render(json: { errors: "An error occurred: #{ e.message }"}, status: 500)
      end

      def update
        render(json: { errors: "Request must include an id param."}, status: 500) and return if params[:id].nil?

        admin = Admin.find_by(id: params[:id])

        if admin
          admin.update(admin_params.slice(:email, :first_name, :last_name))
          # this will automatically use the ArraySerializer for the collection,
          # and the Admin serializer for each admin record in the collection
          render json: admin, adapter: :json_api, key_transform: :underscore
        else
          render(json: { errors: "Admin could not be found"}, status: 404)
        end
      rescue StandardError => e
        render(json: { errors: "An error occurred: #{ e.message }"}, status: 500)
      end


    private

      def load_admins
        @admins = if params[:id]
                    Admin.where(id: params[:id])
                  elsif params[:sso_id] && Admin.new.respond_to?(:sso_id)
                    Admin.where(sso_id: params[:sso_id].downcase)
                  elsif params[:email]
                    Admin.where(email: params[:email].downcase)
                  else
                    []
                  end
      end

      def admin_params
        params.permit(:email, :first_name, :last_name)
      end

    end
  end
end
