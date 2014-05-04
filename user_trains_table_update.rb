require_relative 'user_trains_reader.rb'
require_relative 'database_connect.rb'
require 'pg'

class UserTrainsTableUpdate
  include DatabaseConnect

  attr_reader :db_connection, :table_name

  def self.update!
    new.perform_update
  end

  def initialize
    database_initializer
    @db_connection = database_connection
    @table_name = 'user_trains'
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
        user_trains_id    serial primary key,
        name                    varchar(255),
        train      varchar(200)
      );
      SQL
    )
  end

  def insert_data
    UserTrainsReader.read_user_trains.each do |user_name, trains|
      trains.each do |train_name|
        @db_connection.exec(<<-SQL
          insert into #{table_name} (name, train)
          values ('#{user_name}','#{train_name}')
          SQL
          )
      end
    end
  end

  def display_data
    db_connection.exec(<<-SQL
      select * from #{table_name};
    SQL
    )
  end
end
