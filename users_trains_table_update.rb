require_relative 'database_connect.rb'
require 'pg'

class UsersTrainsTableUpdate
  include DatabaseConnect

  attr_reader :db_connection, :table_name

  def self.update!
    new.perform_update
  end

  def initialize
    database_initializer
    @db_connection = database_connection
    @table_name = 'users_trains'
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
        id            serial primary key,
        user_id       int,
        train_id      int
      );
      SQL
    )
  end

  def insert_data
    [%w[1 1],  # =>  'Alex' '123'
     %w[1 2],  # =>  'Alex' '456'
     %w[2 1],  # =>  'Mario' '123'
     %w[3 4],  # =>  'Isabel' 'ACE'
     %w[3 5],  # =>  'Isabel' 'BDFM'
     %w[4 2],  # =>  'Zach' '456'
     %w[4 5],  # =>  'Zach' 'BDFM'
     %w[4 8]].each do |user, train|  # => 'Zach' 'L'
      @db_connection.exec(<<-SQL
        insert into #{table_name} (user_id, train_id)
        values ('#{user}','#{train}')
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
