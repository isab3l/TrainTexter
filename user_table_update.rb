require_relative 'database_connect.rb'
require 'pg'

class UsersTableUpdate
  include DatabaseConnect

  attr_reader :db_connection, :table_name

  def self.update!
    new.perform_update
  end

  def initialize
    database_initializer
    @db_connection = database_connection
    @table_name = 'users'
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
        id        serial primary key,
        name      varchar(255),
        phone     varchar(200)
      );
      SQL
    )
  end

  def insert_data
    [%w[Alex +16784290938],
     %w[Mario +16262038010],
     %w[Isabel +16262038010],
     %w[Zach +16262038010]].each do |user_name, number|
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
