Rails.application.routes.draw do
  root to: 'contacts#index'

  resources :contacts, only: [:index] do
    member do
      get  'preview_email'
      post 'send_email'
    end
  end

  resources :email_templates do
    member do
      get 'preview' 
    end
  end
end
