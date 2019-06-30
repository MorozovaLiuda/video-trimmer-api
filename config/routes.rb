Rails.application.routes.draw do
  apipie
  namespace :api do
    namespace :v1 do
      resources :videos
      resource :sessions, only: :create
      resource :users, only: :create
    end
  end
end
