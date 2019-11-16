
require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  attr_accessor :name, :grade
  attr_reader :id
  
  def initialize(name, grade, id = nil)
    @name = name
    @grade = grade
    @id = id
end
  
  def self.table_name
      self.to_s.downcase.pluralize
  end
  
  def self.column_names
    DB[:conn].results_as_hash = true
    sql = "pragma table_info('#{table_name}')"

    table_info = DB[:conn].execute(sql)
    column_names = []
    table_info.each do |row|
    column_names << row["name"]
    end
    column_names.compact
    end
    
    def self.column_names_for_insert
      self.class.column_names.delete_if{|col_name| col_name == "id"}.join(", ")
    end
    
    def values_for_insert
      values = []
      self.class.column_names.each do |col_name|
          values << "'#{send(col_name)}'" unless send(col_name).nill?
      end
      values.join(", ")
    end
    
    def save
     sql = "INSERT INTO '#{table_name_for_insert}' (#{col_names_for_insert}) VALUES (#{values_for_insert})"
     DB[:conn].execute(sql)
     @id = DB[:conn].execute("SELECT last_insert_rowid() FROM #{table_name_for_insert}")[0][0]
    end
    
    def self.find_by_name(name)
    sql = DB[:conn].execute("SELECT * FROM #{table_name} WHERE name = ?", name)
    end
    
end
