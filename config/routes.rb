Rails.application.routes.draw do
  root to: 'poker#index'
  post 'calculate', to: 'poker#calculate'

end
