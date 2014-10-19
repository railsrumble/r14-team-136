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

    @ar_decendants

    @tree = []

    @mtm = {}

    @ar_decendants.each do|k|

      @tree << add_sub_class(k, [])

    end

    @tree.each do |node|
        node[:children] = remove_duplicates(node[:children])
    end
    @tree = @tree.sort{|x,y| y[:children].count <=> x[:children].count}


    p "#"*50
    puts JSON.pretty_generate(@tree)


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

  def add_sub_class(klass,repete)

    result = []

    ref = klass.reflections

    p ref


    if ref.blank? || repete.include?(klass)

    else

      repete << klass

      ref.each do |c,rel|
	next if rel.macro == :belongs_to

	p "#{rel.active_record} running"

	begin

	  result << add_sub_class(rel.name.classify.constantize,repete)

	rescue Exception => e

	  @mtm[klass.name] ||= []

	  @mtm[klass.name] << c.to_s.classify

	  if rel.options[:class_name]

	    result << add_sub_class(rel.options[:class_name].to_s.constantize,repete)

	  end

	end

      end

    end

    {:base_class => klass.name, :children => result.uniq}

  end

  def remove_duplicates(children)
    children.uniq
    children.each do |child|
      child[:children] = remove_duplicates(child[:children])
    end
    children
  end

end
