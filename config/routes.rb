Rails.application.routes.draw do
  scope :api, defaults: { format: :json } do
    namespace :v1 do

      resources :users, only: :create do
        collection do
          patch :update
          put :update
          delete :destroy
        end
      end

      post 'authorization', to: 'authorization#create'
      delete 'authorization', to: 'authorization#destroy'

    end
  end
end
