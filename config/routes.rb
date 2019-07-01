Rails.application.routes.draw do
  apipie
  namespace :api, defaults: {format: 'json'} do
    scope module: :v1, constraints: ApiConstraints.new(version: 1) do
      resources :videos
      resource :sessions, only: :create
      resource :users, only: :create
    end
  end
end
