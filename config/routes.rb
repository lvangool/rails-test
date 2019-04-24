Rails.application.routes.draw do
  root 'rat_race#results'
  post 'run', to: 'rat_race#run'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
