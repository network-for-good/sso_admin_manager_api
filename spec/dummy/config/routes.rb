Rails.application.routes.draw do

  mount SsoAdminManagerApi::Engine => "/sso_admin_manager_api"

end
