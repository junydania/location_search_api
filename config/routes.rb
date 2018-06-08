Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :v1 do 
      post "/places", to: "places#search_places", as: "google_places"
  end

end
