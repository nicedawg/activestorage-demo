Rails.application.routes.draw do
  root to: "memes#index"

  resources :memes
  namespace :memes do
    resources :images, only: :show
  end
end
