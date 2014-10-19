Rails.application.routes.draw do
  get "/surge" => 'surge_management#index'
  post "/generate_migrations" => 'surge_management#generate_migration'
end
