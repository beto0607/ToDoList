Rails.application.routes.draw do
  resources :users do
    resources :lists, shallow:true do
        resources :comments, shallow:true, except:[:show]
        resources :items, shallow:true, except:[:show]
    end
  end
  post "/auth/login", to: "authentication#login"
end
