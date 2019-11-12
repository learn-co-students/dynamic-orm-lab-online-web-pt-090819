require 'pry'
require_relative "../config/environment.rb"
require 'active_support/inflector'

class InteractiveRecord
  
    def self.table_name
        self.to_s.downcase.pluralize
    end

    def self.column_names
        DB[:conn].results_as_hash = true

        sql = "pragma table_info('#{table_name}')"

        table_info = DB[:conn].execute(sql)
        column_names = []
        table_info.each{|row| column_names << row["name"]}
        column_names.compact
    end

    def initialize(attributes={})
        attributes.each{|property, value| self.send("#{property}=", value)}
    end

    def table_name_for_insert
        
    end

end