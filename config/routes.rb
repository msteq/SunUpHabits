Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: "/letter_opener" if Rails.env.development?

  root "static_pages#top"
  get "terms", to: "static_pages#terms", as: :terms
  get "privacy", to: "static_pages#privacy", as: :privacy
  get "contact", to: "static_pages#contact", as: :contact

  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords",
    omniauth_callbacks: "users/omniauth_callbacks"
  }

  get "my_page", to: "users#show", as: :my_page

  resources :habits do
    member do
      post "achieve"
      post "not_achieve"
    end
  end

  get "my_habits", to: "habits#index", as: "my_habits"

  resources :posts, only: [ :index, :show, :new, :create ] do
    get :autocomplete, on: :collection
    resources :comments, only: [ :create, :destroy ]
    resources :likes, only: [ :create, :destroy ]
  end
end
