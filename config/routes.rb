Rails.application.routes.draw do
  resources :users
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
end
