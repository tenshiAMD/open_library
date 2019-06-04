Rails.application.routes.draw do
  devise_for :users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "home#index"

  get "/documents/search", controller: :home, action: :index
  post "/documents/share", controller: :home, action: :share,
                           as: :documents_share

  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?
end
