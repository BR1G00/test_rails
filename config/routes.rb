Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root to: 'home#index'

  namespace :api do
    resources :posts, only: [:index] do
      collection do
        get 'search/:term', action: :search
      end
    end
  end
end