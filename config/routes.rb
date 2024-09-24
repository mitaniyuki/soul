Rails.application.routes.draw do
  devise_for :users
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.

  # Defines the root path route ("/")
  # root "posts#index"

  get 'tweets/top' => 'tweets#top'
  get 'tweets/index'  => 'tweets#index'
  get 'tweets/job'  => 'tweets#job'
  get 'tweets/dog'  => 'tweets#dog'
  get 'tweets/cat'  => 'tweets#cat'
  get 'tweets/apple'  => 'tweets#apple'
  get 'tweets/orenge'  => 'tweets#orenge'
  get 'tweets/grape'  => 'tweets#grape'
  get 'tweets/kiwi'  => 'tweets#kiwi'
  get 'tweets/mango'  => 'tweets#mango'
  get 'tweets/pear'  => 'tweets#pear'
  get 'tweets/berry'  => 'tweets#berry'
  get 'tweets/peach'  => 'tweets#peach'
  get 'tweets/cherry'  => 'tweets#cherry'
  get 'tweets/lemon'  => 'tweets#lemon'
  get 'tweets/tomato'  => 'tweets#tomato'
  get 'tweets/melon'  => 'tweets#melon'
  get 'tweets/corn'  => 'tweets#corn'


  resources :tweets do
   resources :likes, only: [:create, :destroy]
   resources :comments, only: [:create]
  end


  root 'tweets#top'


  

end
