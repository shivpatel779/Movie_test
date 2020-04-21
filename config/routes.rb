Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    namespace :v1 do
      post 'best_seat_available', to: 'movies#best_seat_available'
      resources :movies
    end
  end
end
