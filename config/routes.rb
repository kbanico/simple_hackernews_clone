Rails.application.routes.draw do

  root 'links#index'

  resources :links, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
  end

  get "/comments" => "comments#index"

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :users, only: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
