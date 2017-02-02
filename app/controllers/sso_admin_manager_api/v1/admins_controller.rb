require 'sso_admin_manager_api/secure_api'

module SsoAuthenticationApi
  module V1
    module Admins
      class AuthenticationsController < ActionController::Base
        include SsoAuthenticationApi::TokenAuthentication

        before_filter :authorize_nfg_request!
        before_filter :load_admin

        respond_to :json

        def update
          # byebug
          render(json: { errors: "Request must include an email param"}, status: 500) and return if params[:id].nil?
          render(json: { errors: "Admin could not be found"}, status: 404) and return unless @admin

          respond_with  @admin, serializer: SsoAuthenticationApi::V1::AdminSerializer, location: nil, status: @status
        end


      private

        def skip_track_action
          # no reason to add ahoy event records for api requests
          true
        end

        def load_admin
          query = Admin.where(email: param[:id], id: param[:id], sso_id: param[:id])
          @admin = Admin.where(query.where_values.inject(:or)).first
        end

        def first_authenticated_admin(admins)
          # return the first admin that can be authenticated using the passed password
          admins.select { |admin| authenticate_user(admin, params[:password]) }.first
        end

        def authenticate_user(admin, password)
          admin.valid_password?(password)
        end
      end
    end
  end
end
