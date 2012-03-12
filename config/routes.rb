Quora::Application.routes.draw do
  resources :questions do
    collection do
      get :byme
      get :answered
    end
  end
  
  resources :answers do
    member do
      post :vote_up
      post :vote_down
    end
  end
  
  # -- 用户登录认证相关 --
  root :to=>"index#index"
  get  '/login'  => 'sessions#new'
  post '/login'  => 'sessions#create'
  get  '/logout' => 'sessions#destroy'
  
  get  '/signup'        => 'signup#form'
  post '/signup_submit' => 'signup#form_submit'
end
