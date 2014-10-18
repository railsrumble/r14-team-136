class SurgeManagementController < ApplicationController
  layout "surge"

  before_action :set_folder_paths

  def index

  end

  private

  def set_folder_paths
    p session[:id]
    if Rails.env.production?
      session[:id]
    else

    end
  end
end
