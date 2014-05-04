require_relative 'user_numbers_table_update.rb'
require_relative 'user_notification_times_table_update.rb'
require_relative 'user_trains_table_update.rb'
require 'pg'

class UserRetriever
  include DatabaseConnect

  def self.get_users
    new.determine_users
  end

  def initialize
    database_initializer
    @db_connection = database_connection
  end

  def determine_users
    determine_notification_user(determine_notification_time)
  end

  def determine_notification_times
    # find notification times that are >= current time
    # order them by time asc
    # select the first
  end

  def determine_notification_user(notification_time)
    # go into the join table to match notification time id with user id
    # retreive all users(id, name, phone) with determined notification time
  end

end
