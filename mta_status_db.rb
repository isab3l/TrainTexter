require_relative 'file_reader.rb'
require 'pg'

class UpdateDatabase

	attr_reader :database_name, :db_connection

	def self.update!
		new.perform_update
	end

	def initialize(database_name = 'mta_status_updates')
		@database_name = database_name
		@db_connection = PG.connect(database_name)
	end

	def perform_update
		database_utilities
		create_table
		insert_data
		display_data
	end

	def database_utilities
		ignore_errors = "/dev/null 2>&1"
		`createdb #{database_name} #{ignore_errors}`
		db_connection.exec("drop table if exists trains;")
	end

	def create_table
		db_connection.exec(<<-SQL
		  create table trains
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
					insert into trains (line, status)
					values ('#{train}','#{cur_status}');
				SQL
				)
		end
	end

	def display_data
		results = db_connection.exec(<<-SQL
			select * from trains;
		SQL
		)
	end
end

p UpdateDatabase.update!
