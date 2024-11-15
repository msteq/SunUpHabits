Rails.application.routes.draw do
  # ルートパスの設定
  root "static_pages#top"

  # Deviseのルーティングをカスタムコントローラーで設定
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

end
