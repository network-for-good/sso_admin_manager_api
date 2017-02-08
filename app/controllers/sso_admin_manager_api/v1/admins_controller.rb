require 'sso_admin_manager_api/secure_api'

module SsoAdminManagerApi
  module V1
    class AdminsController < ActionController::Base
      include SsoAdminManagerApi::TokenAuthentication
      respond_to :json

      before_filter :authorize_nfg_request!
      before_filter :verify_id_param

      def index
        load_admins

        if @admins.present?
          render json: @admins, adapter: :json_api, meta: { record_count: @admins.length }
        else
          render(json: { errors: "Admin could not be found"}, status: 404)
        end

      rescue StandardError => e
        render(json: { errors: "An error occurred: #{ e.message }"}, status: 500)
      end

      def update
        admin = Admin.find_by(id: params[:id])

        if admin
          admin.update(admin_params.slice(:email, :first_name, :last_name))
          # this will automatically use the ArraySerializer for the collection,
          # and the Admin serializer for each admin record in the collection
          render json: admin, adapter: :json_api
        else
          render(json: { errors: "Admin could not be found"}, status: 404)
        end
      rescue StandardError => e
        render(json: { errors: "An error occurred: #{ e.message }"}, status: 500)
      end


    private

      def load_admins
        @admins = if number?(params[:id])
                    base_admin_scope.where(id: params[:id])
                  elsif Admin.new.respond_to?(:sso_id)
                    base_admin_scope.where(["email = ? or sso_id = ?", params[:id], params[:id]])
                  else
                    base_admin_scope.where(email: params[:id])
                  end
      end

      def number?(obj)
        obj = obj.to_s unless obj.is_a? String
        /\A[+-]?\d+(\.[\d]+)?\z/.match(obj)
      end

      def admin_params
        params.permit(:email, :first_name, :last_name)
      end

      def base_admin_scope
        Admin.active
      end

      def verify_id_param
        ender(json: { errors: "Request must include an id param. The id param can set to one of the following:  email, internal id, or sso_id"}, status: 500) if params[:id].nil?
      end

    end
  end
end
