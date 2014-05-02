require_relative 'file_reader.rb'
require 'pg'

class UpdateDatabase
	DATABASE_NAME = 'mta_status_updates'

	def self.update_database
		ignore_errors = "/dev/null 2>&1"
		`createdb #{DATABASE_NAME} #{ignore_errors}`

		db_connection = PG.connect( dbname: DATABASE_NAME )

		db_connection.exec("drop table if exists trains;")

		db_connection.exec(<<-SQL
		  create table trains
		  (
		  	id				serial primary key,
		    line  		varchar(255),
		    status 		varchar(255)
		  );
		  SQL
		)

		StatusUpdate.get_status_update.each do |train, cur_status|
			db_connection.exec(<<-SQL
					insert into trains (line, status)
					values ('#{train}','#{cur_status}');
				SQL
				)
		end

		results = db_connection.exec(<<-SQL
			select * from trains;
		SQL
		)
	end
end