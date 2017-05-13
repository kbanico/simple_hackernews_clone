Rails.application.routes.draw do
  # tutorial link
  # https://www.codementor.io/danielchinedu/building-a-basic-hacker-news-clone-with-rails-5-4gr4hrbis

  root 'links#index'

  resources :links, except: :index do
    resources :comments, only: [:create, :edit, :update, :destroy]
    post :upvote, on: :member
    post :downvote, on: :member
  end

  get "/comments" => "comments#index"

  resources :sessions, only: [:new, :create] do
    delete :destroy, on: :collection
  end

  resources :users, only: [:new, :create]

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
