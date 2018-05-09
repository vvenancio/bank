Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :people, except: :index
      resources :companies, except: :index
      resources :bank_accounts, except: :index

      post 'bank_account/:id/deposit' => 'bank_accounts#deposit'
    end
  end
end
