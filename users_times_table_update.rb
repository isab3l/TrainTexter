require_relative 'database_connect.rb'
require 'pg'

class UsersTimesTableUpdate
  include DatabaseConnect

  attr_reader :db_connection, :table_name

  def self.update!
    new.perform_update
  end

  def initialize
    database_initializer
    @db_connection = database_connection
    @table_name = 'users_times'
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
        id                        serial primary key,
        user_id                   int,
        notification_time_id      int
      );
      SQL
    )
  end

  def insert_data
    [%w[1 2],  # =>  'Alex' '08:00'
     %w[1 8],  # =>  'Alex' '20:00'
     %w[2 3],  # =>  'Mario' '10:00'
     %w[2 6],  # =>  'Mario' '16:00'
     %w[3 5],  # =>  'Isabel' '08:00'
     %w[3 4],  # =>  'Isabel' '12:00'
     %w[4 1],  # =>  'Zach' '06:00'
     %w[4 7],  # => 'Zach' '18:00'
     %w[5 6]].each do |user, time|  # => 'Connor' '16:00'
      @db_connection.exec(<<-SQL
        insert into #{table_name} (user_id, notification_time_id)
        values ('#{user}','#{time}')
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
