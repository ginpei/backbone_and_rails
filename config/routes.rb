BackboneAndRails::Application.routes.draw do
  resources :tasks, only: [:index, :create, :show, :update, :destroy]
  root 'tasks#index'
end
