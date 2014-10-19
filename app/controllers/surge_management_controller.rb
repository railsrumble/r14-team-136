require 'fileutils'

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

  def test
    system("rails destroy model test1 ")
    rafeeq
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
