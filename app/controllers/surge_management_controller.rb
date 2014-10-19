require 'fileutils'
require 'rake'
require 'migration_writer'

class SurgeManagementController < ApplicationController
  include MigrationWriter
  layout "surge"
  skip_before_filter :verify_authenticity_token

  before_action :set_folder_paths
  def index
    @all_tables = ActiveRecord::Base.connection.tables
    @all_classes = {}

    Rails.application.eager_load!
    @ar_decendants = ActiveRecord::Base.descendants.reject{|x| x == ActiveRecord::SchemaMigration}
    p  @ar_decendants
    @ar_decendants.each do |klass|
      @all_classes[klass.to_s.classify.split("::").join(" ").split("HABTM").sort.each{|x| x.strip!}] = klass.descendants.collect{|x| x.to_s.classify.split("::").join(" ").split("HABTM").each{|x| x.strip!} }
    end
    @ar_decendants

    @tree = []

    @mtm = {}

    @ar_decendants.each do|k|

      @tree << add_sub_class(k, [])

    end

    p @tree

    @tree.each do |node|
      node[:children] = remove_duplicates(node[:children])
    end
    @tree = @tree.sort{|x,y| y[:children].count <=> x[:children].count}

    p "#"*50
    puts JSON.pretty_generate(@tree)

  end

  def create_model

    if params[:new_model] && params[:new_model][:model_name]
      cols_string = ""
      params[:new_model][:column_data].each do|i,col|
        cols_string += "#{col[:column_name]}:#{col[:data_type]} "
      end
      system("rails generate model #{params[:new_model][:model_name]} #{cols_string}")
    #Rails.application.class.load_tasks
    #Rake::Task['db:migrate'].invoke
    end
    redirect_to :back
  end

  def generate_migrations
    all_params = []
    if params[:add_column] && params[:add_column][:column_data]
      p "11111111111"
      params[:add_column][:column_data].each do |i,cdata|
        if cdata[:column_name]
          add_column = {}
          add_column[:action] = "add_column"
          add_column[:table_name] = params[:add_column][:table_name].constantize.table_name
          add_column[:column_name] = cdata[:column_name]
          add_column[:datatype] = cdata[:data_type]
        all_params << add_column
        end
      end
    end
    if params[:remove_column] && params[:remove_column][:column_name] != ""
      remove_column = {}
      remove_column[:action] = "remove_column"
      remove_column[:table_name] = params[:remove_column][:table_name].constantize.table_name
      remove_column[:column_name] = params[:remove_column][:column_name]
      remove_column[:data_type] = params[:remove_column][:table_name].constantize.columns.select{|c| c.name==params[:remove_column][:column_name]}.first.type
    all_params << remove_column
    end

    if params[:rename_table] && params[:rename_table][:new_table_name] != ''
      all_params <<  {:action => "rename_table" , :table_data => {:old_table_name => params[:rename_table][:old_table_name].constantize.table_name , :new_table_name => params[:rename_table][:new_table_name]}}
    end

    if params[:rename_column] && params[:rename_column][:old_column_name] != "" && params[:rename_column][:new_column_name] != ""
      all_params << {:action => "rename_column" , :table_name => params[:rename_column][:table_name].constantize.table_name, :old_column_name => params[:rename_column][:old_column_name] ,:new_column_name => params[:rename_column][:new_column_name]}
    end
    @file = create_migration_file(all_params)
    if params[:drop_model][:drop_model]
      system("rails destroy model #{params[:drop_model][:model_name]}")
    end
    redirect_to :back
  end

  def get_columns
    p "In get_columns s\action of controller"
    render :json => params["table_name"].constantize.columns.collect{|c| c.name}
  end

  def create_table
    if params[:new_table] && params[:new_table][:table_name] != ""
      column_data = []
      params[:new_table][:column_data].each do |i,val|
        if val[:column_name] != "" && val[:column_name] != nil && val[:datatype] != "" && val[:datatype] != nil
          column_data << {:column_name => val[:column_name] , :datatype => val[:data_type], :limit => val[:limit], :null => val[:null], :default => vla[:default]}
        end
        create_migration_file([{:action => "create_table" , :table_name => params[:new_table][:table_name].constantize.table_name , :column_data => column_data }])
      end
    end

    redirect_to :back
  end

  def drop_table
    if params[:table_name]
      create_migration_file([{:action => "drop_table" , :table_name => params[:table_name] ,:method_up => "up" , :method_down => "down"}])
    end
    redirect_to :back
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
  end

  def add_sub_class(klass,repeat)

    result = []

    ref = klass.reflections

    if ref.blank? || repeat.include?(klass)

      else

      repeat << klass

      ref.each do |c,rel|
        next if rel.macro == :belongs_to

        result << add_sub_class(rel.name.to_s.classify.constantize,repeat)

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
