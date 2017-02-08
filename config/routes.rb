SsoAdminManagerApi::Engine.routes.draw do
  namespace :v1 do
    resources :admins, only: [:index, :update]

    # this is a catchall for the namespace, so we don't return the apps 404 page when
    # a path is requested that does not match any in this routes file.
    match "*path", to: -> (env) { [404, {}, ['{"error": "not_found"}']] }, via: :all
  end
end
