SsoAdminManagerApi::Engine.routes.draw do
  namespace :v1 do
    resources :admins, only: [:update]
  end
end
