require_relative 'database_connect.rb'
require 'pg'

class NotificationTimesTableUpdate
  include DatabaseConnect

  attr_reader :db_connection, :table_name

  def self.update!
    new.perform_update
  end

  def initialize
    database_initializer
    @db_connection = database_connection
    @table_name = 'notification_times'
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
        id                    serial primary key,
        notification_time     varchar(255)
      );
      SQL
    )
  end

  def insert_data
    ["06:00","08:00","10:00","12:00",
    "14:00","16:00", "18:00", "20:00"].each do |time|
      @db_connection.exec(<<-SQL
        insert into #{table_name} (notification_time)
        values ('#{time}')
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
