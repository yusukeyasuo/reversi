Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "game#index"
  get "game/index" => "game#index"
  get "game/play/:id" => "game#play"
end
