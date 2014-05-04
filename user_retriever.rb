require_relative 'database_connect.rb'
require 'pg'

class UserRetriever
  include DatabaseConnect

  attr_reader :db_connection

  def self.get_users
    new.determine_users
  end

  def initialize
    database_initializer
    @db_connection = database_connection
  end

  def determine_users
    determine_notification_user(determine_next_notification_time_id)
  end

  private

  def determine_next_notification_time_id
    db_connection.exec(<<-SQL
    select * from notification_times
    where extract(hour from to_timestamp(notification_time, 'HH24'))
        >= extract(hour from current_time);
    SQL
    ).first.values[0]
  end

  def determine_notification_user(notification_time)
  db_connection.exec(<<-SQL
    select users.id, users.name, users.phone from users
    join users_times on users.id = users_times.user_id
    where users_times.notification_time_id = #{notification_time}
    SQL
    )
  end

end
