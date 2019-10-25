Rails.application.routes.draw do
   resources :tests do
      member do
         get 'edit'
         get 'jenkins_build'
      end
   end
   resources :builds do
      member do
         get 'refresh'
         get 'jenkins_refresh'
         get 'jenkins_stop'
      end
   end
   resources :tags do
      collection do
         get 'all'
         get 'owner'
         get 'edit'
      end
   end
   resources :notes
   get '/environment_tags/select_env/:id', to: 'environment_tags#select_environment', as: 'change_env'
   get '/environment_tags/toggle_rotate', to: 'environment_tags#toggle_rotate', as: 'toggle_rotate'
   root to: 'tags#index'
end
