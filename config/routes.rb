Rails.application.routes.draw do
  get "/surge" => 'surge_management#index'

  
  get "/get_columns" => 'surge_management#get_columns'

end
