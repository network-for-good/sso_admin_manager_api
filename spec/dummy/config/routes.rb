Rails.application.routes.draw do

  mount SsoAuthenticationApi::Engine => "/sso_admin_manager_api"

end
