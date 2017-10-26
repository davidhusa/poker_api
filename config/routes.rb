Rails.application.routes.draw do
  root to: 'welcome#index'
  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      post 'calculate', to: 'poker#calculate'
    end
  end
end
