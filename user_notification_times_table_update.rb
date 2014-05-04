require_relative 'user_time_reader.rb'
require_relative 'database_connect.rb'
require 'pg'

class UserNotificationTimesTableUpdate
  include DatabaseConnect

  attr_reader :db_connection, :table_name

  def self.update!
    new.perform_update
  end

  def initialize
    database_initializer
    @db_connection = database_connection
    @table_name = 'user_notification_times'
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
        user_notification_time_id     serial primary key,
        name                          varchar(255),
        notification_time             varchar(200)
      );
      SQL
    )
  end

  def insert_data
    UserTimeReader.read_user_notifcation_times.each do |user_name, times|
      times.each do |time|
        @db_connection.exec(<<-SQL
          insert into #{table_name} (name, notification_time)
          values ('#{user_name}','#{time}')
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