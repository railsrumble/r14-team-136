require 'fileutils'
require 'rake'

class SurgeManagementController < ApplicationController
  layout "surge"

  before_action :set_folder_paths
  def index
    @all_classes = {}

    Rails.application.eager_load!
    @ar_decendants = ActiveRecord::Base.descendants
    @ar_decendants.each do |klass|
      @all_classes[klass.to_s.classify.split("::").join(" ").split("HABTM").sort.each{|x| x.strip!}] = klass.descendants.collect{|x| x.to_s.classify.split("::").join(" ").split("HABTM").each{|x| x.strip!} }
    end

    p @all_classes

  end

  def create_model
    cols_string = ""
    params[:new_model][:column_data].each do|i,col|
      cols_string += "#{col[:column_name]}:#{col[:data_type]} "
    end
    system("rails generate model #{params[:new_model][:model_name]} #{cols_string}")
    Rails.application.class.load_tasks
    Rake::Task['db:migrate'].invoke
    redirect_to :back
  end
  def drop_model
    system("rails destroy model #{params[:model_name]}")
    redirect_to :back
  end
  
  def generate_migrations
    rafeeq
  end
  def get_columns
    p "In get_columns s\action of controller"
    render :json => params["table_name"].constantize.columns.collect{|c| c.name}
  end

  private

  def set_folder_paths
    #if Rails.env.production?
    if File.directory?(Rails.root.to_s + "/tmp/#{request.session_options[:id]}")
      p "Exists"
    else
      p Rails.root.to_s + "/tmp/#{request.session_options[:id]}" + " Does not exists"
      p "creating folder"
      FileUtils::mkdir_p Rails.root.to_s + "/tmp/#{request.session_options[:id]}/models"
      FileUtils::mkdir_p Rails.root.to_s + "/tmp/#{request.session_options[:id]}/migrate"
      p File.directory?(Rails.root.to_s + "/tmp/#{request.session_options[:id]}")
      FileUtils.cp_r Rails.root.to_s + "/app/models",  Rails.root.to_s + "/tmp/#{request.session_options[:id]}/models"
      FileUtils.cp_r Rails.root.to_s + "/db/migrate",  Rails.root.to_s + "/tmp/#{request.session_options[:id]}/migrate"

    end
  #else

  #end
  end
end
