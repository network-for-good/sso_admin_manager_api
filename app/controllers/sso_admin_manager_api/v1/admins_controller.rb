require 'sso_admin_manager_api/secure_api'

module SsoAdminManagerApi
  module V1
    class AdminsController < ActionController::Base
      include SsoAdminManagerApi::TokenAuthentication
      respond_to :json

      before_filter :authorize_nfg_request!
      before_filter :load_admin

      def update
        # byebug
        render(json: { errors: "Request must include an email param"}, status: 500) and return if params[:id].nil?
        render(json: { errors: "Admin could not be found"}, status: 404) and return unless @admin

        @admin.update(admin_params.slice(:email, :first_name, :last_name))

        respond_with  @admin, serializer: SsoAdminManagerApi::V1::AdminSerializer, location: nil, status: @status
      end


    private

      def skip_track_action
        # no reason to add ahoy event records for api requests
        true
      end

      def load_admin
        # discussion of how this works to create an or statement
        # https://coderwall.com/p/dgv7ag/or-queries-with-arrays-as-arguments-in-rails-4
        if number?(params[:id])
          @admin = Admin.active.find_by(id: params[:id])
        else
          @admin = Admin.active.find_by(email: params[:id]) || Admin.active.find_by(sso_id: params[:id])
        end
      end

      def number?(obj)
        obj = obj.to_s unless obj.is_a? String
        /\A[+-]?\d+(\.[\d]+)?\z/.match(obj)
      end

      def admin_params
        params.permit(:email, :first_name, :last_name)
      end

    end
  end
end
