Rails.application.routes.draw do
  root 'welcome#home'

  resources :users do
    get "/change_password" => "users#change_password"
  end
  resources :password_resets, only: [:new, :create, :edit, :update]
  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end
end
