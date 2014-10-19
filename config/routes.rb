Rails.application.routes.draw do
  get "/surge" => 'surge_management#index'
  post "/create_model" => 'surge_management#test'
  post "/drop_model" => 'surge_management#test'
  
  get "/get_columns" => 'surge_management#get_columns'
end
