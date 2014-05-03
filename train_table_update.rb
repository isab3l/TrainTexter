require_relative 'file_reader.rb'
require_relative 'database_connect.rb'
require 'pg'

class TrainTableUpdate
	include DatabaseConnect

	attr_reader :db_connection, :table_name

	def self.update!
		new.perform_update
	end

	def initialize
		database_initializer
		@db_connection = database_connection
		@table_name = 'trains'
	end

	def perform_update
		drop_table
		create_table
		insert_data
		display_data
	end

	private

	def drop_table
		db_connection.exec("drop table if exists #{table_name};")
	end

	def create_table
		db_connection.exec(<<-SQL
		  create table #{table_name}
		  (
		  	id				serial primary key,
		    line  		varchar(255),
		    status 		varchar(255)
		  );
		  SQL
		)
	end

	def insert_data
		FileReader.parse.each do |train, cur_status|
			db_connection.exec(<<-SQL
					insert into #{table_name} (line, status)
					values ('#{train}','#{cur_status}');
				SQL
				)
		end
	end

	def display_data
		results = db_connection.exec(<<-SQL
			select * from #{table_name};
		SQL
		)
	end
end
