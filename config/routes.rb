Rails.application.routes.draw do
  root "sessions#new"
  get 'password_resets/new'

  resources :users do
    get "/change_password" => "users#change_password"
  end
  resources :password_resets
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
end
