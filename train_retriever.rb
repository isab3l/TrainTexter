require_relative 'user_trains_table_update.rb'
require_relative 'trains_table_update.rb'
require 'pg'

class TrainRetriever
  include DatabaseConnect

  attr_reader :user_id

  def self.get_trains(user_id)
    new(user_id).determine_trains_for_user
  end

  def initialize(user_id)
    database_initializer
    @db_connection = database_connection
    @user_id = user_id
  end

  def determine_trains_for_user
    # go in user-train table and match user_id with train_id
    # find trains that correspond to train_id
    db_connection.exec(<<-SQL
      select * from 'user-trains';
    SQL
    )
  end

end
