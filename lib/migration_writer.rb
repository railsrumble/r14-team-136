module MigrationWriter
  def create_table_writer(param , f)
    p "IN create_table"
    f.write("			#{param[:action]} :#{param[:table_name]} do |t| \n")
    param[:column_data].each do |column|
      f.write("     t.#{column[:datatype]} :#{column[:column_name]} , :limit => #{column[:limit]} , :null => #{column[:null]},:default =>'#{column[:default]}'   \n")
    end
    f.write("     t.timestamps \n")
    f.write("   end\n")
  end

  def drop_table_writer(param , f)
    f.write("   def #{param[:method_up]} \n")
    f.write("			#{param[:action]} :#{param[:table_name]} \n")
    f.write("   end \n")
    f.write("   def #{param[:method_down]} \n")

    f.write(" raise ActiveRecord::IrreversibleMigration \n")

    f.write("   end \n")
  end

  def rename_table_writer(param , f)
    p "In rename table"

    f.write(" #{param[:action]} :#{param[:table_data][:old_table_name]} , :#{param[:table_data][:new_table_name]} \n")
  end

  def add_column_writer(param , f)
    p "In add_column_writer"
    f.write(" #{param[:action]} :#{param[:table_name]} , :#{param[:column_name]} , :#{param[:datatype]} \n")
  end

  def rename_column_writer(param ,f)
    f.write("#{param[:action]}  :#{param[:table_name]} , :#{param[:old_column_name]} , :#{param[:new_column_name]} \n")
  end

  def remove_column_writer(param , f)
    f.write("#{param[:action]} :#{param[:table_name]} , :#{param[:column_name]} ,:#{param[:data_type]} \n")
  end

  def change_column_writer(param , f)

    f.write("#{param[:action]}  :#{param[:table_name]} , :#{param[:column_name]} , :#{param[:datatype]} \n")
  end

  def add_reference_writer(param , f)

    f.write(" #{param[:action]}  :#{param[:table_name]} , :#{param[:reference_table]} , :index => true \n")

  end

  def create_migration_file(all_params)
    a_params = []
    b_params = []
    all_params.each do |param|
      if param[:action] == "drop_table" || param[:action] == "drop_table"
      a_params << param
      else
      b_params << param
      end
    end

    a_params.each do |param|
      if param[:action] == "drop_table"
        File.open("db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_surge_migration_#{(Time.now+60).utc.strftime("%Y%m%d%H%M%S")}.rb", "a+") do |f|
          f.write("class SurgeMigration#{(Time.now+60).utc.strftime("%Y%m%d%H%M%S")} < ActiveRecord::Migration \n")

          updated_file = drop_table_writer(param , f)

          f.write("end \n")
        end
      end
    end

    File.open("db/migrate/#{Time.now.utc.strftime("%Y%m%d%H%M%S")}_surge_migration_#{Time.now.utc.strftime("%Y%m%d%H%M%S")}.rb", "a+") do |f|
      f.write("class SurgeMigration#{Time.now.utc.strftime("%Y%m%d%H%M%S")} < ActiveRecord::Migration \n")
      f.write("   def change \n")
      b_params.each   do |param|
        updated_file = create_table_writer(param , f) if param[:action] == "create_table"
        updated_file = rename_table_writer(param , f) if param[:action] == "rename_table"
        updated_file = add_column_writer(param , f) if param[:action] == "add_column"
        updated_file = rename_column_writer(param ,f) if param[:action] == "rename_column"
        updated_file = remove_column_writer(param , f) if param[:action] == "remove_column"
        updated_file = change_column_writer(param , f) if param[:action] == "change_column"
        updated_file = add_reference_writer(param , f) if param[:action] == "add_reference"

      end
      f.write("   end \n")
      f.write("end \n")
    end
  end
end
