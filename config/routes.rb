Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "home#index"

  get "/documents/search", controller: :home, action: :index
end
