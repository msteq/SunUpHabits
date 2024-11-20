Rails.application.routes.draw do
  # ルートパスの設定
  root "static_pages#top"

  # Deviseのルーティングをカスタムコントローラーで設定
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions"
  }

  # Habitsのルーティング
  resources :habits do
    member do
      post 'achieve'
      post 'not_achieve'
    end
  end

  # マイ習慣画面へのルートを設定
  get "my_habits", to: "habits#index", as: "my_habits"
end
