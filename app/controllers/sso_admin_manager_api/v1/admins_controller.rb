require 'sso_admin_manager_api/secure_api'

module SsoAdminManagerApi
  module V1
    class AdminsController < ActionController::Base
      include SsoAdminManagerApi::TokenAuthentication
      respond_to :json

      before_filter :authorize_nfg_request!
      before_filter :load_admins

      def update
        # byebug
        render(json: { errors: "Request must include an email param"}, status: 500) and return if params[:id].nil?
        render(json: { errors: "Admin could not be found"}, status: 404) and return unless @admins.present?

        @admins.each do |admin|
          admin.update(admin_params.slice(:email, :first_name, :last_name))
        end

        # this will automatically use the ArraySerializer for the collection,
        # and the Admin serializer for each admin record in the collection
        render json: @admins
      rescue StandardError => e
        render(json: { errors: "An error occurred: #{ e.message }"}, status: 500)
      end


    private

      def skip_track_action
        # no reason to add ahoy event records for api requests
        true
      end

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

    end
  end
end
