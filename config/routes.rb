Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :people, except: :index
      resources :companies, except: :index
      resources :bank_accounts, except: :index

      post 'bank_account/:id/deposit' => 'bank_accounts#deposit'
      post 'bank_account/:from_account_id/transfer/:to_account_id' => 'bank_accounts#transfer'
      post 'bank_account/reverse_debit' => 'bank_accounts#reverse_debit'
    end
  end
end
