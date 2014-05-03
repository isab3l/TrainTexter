require_relative 'file_reader.rb'
require_relative 'database_connect.rb'
require 'pg'

class UserTableUpdate
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
        user_id   serial primary key,
        name      varchar(255),
        phone     varchar(200)
      );
      SQL
    )
  end

  def insert_data
    [%w[Alex 0000000000],
    %w[Mario +18185364199],
    %w[Isabel +17724869106],
    %w[Zach +12127293997]].each do |user|
      @db_connection.exec(<<-SQL
        insert into users(name, phone)
        values ( '#{user.join("','")}' )
        # returning user_id;
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

p UserTableUpdate.update!.values
