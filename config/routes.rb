Rails.application.routes.draw do
  get "/surge" => 'surge_management#index'
  post "/generate_migrations" => 'surge_management#generate_migrations'

  post "/create_model" => 'surge_management#create_model'
  post "/create_table" => 'surge_management#create_table'
  post "/drop_table" => 'surge_management#drop_table'
end
