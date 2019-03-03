Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "game#index"
  get "game" => "game#index"
  get "game/play/:id" => "game#play"
  post "game/create" => "game#create"
  post "game/move/:id" => "game#move", as: 'move'
end
