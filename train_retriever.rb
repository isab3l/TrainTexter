require_relative 'database_connect.rb'
require 'pg'

class TrainRetriever
  include DatabaseConnect

  attr_reader :db_connection, :user_id

  def self.get_trains(user_id)
    new(user_id).determine_trains_for_user
  end

  def initialize(user_id)
    database_initializer
    @db_connection = database_connection
    @user_id = user_id
  end

  def determine_trains_for_user
    db_connection.exec(<<-SQL
      select line, status from trains
      join users_trains on trains.id = users_trains.train_id
      where users_trains.user_id = #{user_id}
      SQL
    )
  end

end
