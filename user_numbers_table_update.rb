require_relative 'user_number_reader.rb'
require_relative 'database_connect.rb'
require 'pg'

class UserNumbersTableUpdate
  include DatabaseConnect

  attr_reader :db_connection, :table_name

  def self.update!
    new.perform_update
  end

  def initialize
    database_initializer
    @db_connection = database_connection
    @table_name = 'user_numbers'
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
        user_id   serial primary key,
        name      varchar(255),
        phone     varchar(200)
      );
      SQL
    )
  end

  def insert_data
    UserNumberReader.read_user_number.each do |user_name, number|
      @db_connection.exec(<<-SQL
        insert into #{table_name} (name, phone)
        values ('#{user_name}','#{number}')
        SQL
        )
    end
  end

  def display_data
    db_connection.exec(<<-SQL
      select * from #{table_name};
    SQL
    )
  end
end