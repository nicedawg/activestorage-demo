Rails.application.routes.draw do
  root to: "memes#index"

  resources :memes

  get 'images/:variant/:id', to: "attachments#show", as: :attachment
end
