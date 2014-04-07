BackboneAndRails::Application.routes.draw do
  resources :tasks, only: [:index, :create, :update, :destroy]
end
