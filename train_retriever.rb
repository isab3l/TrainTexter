
class TrainRetriever
  include DatabaseConnect
  attr_reader :user_id

  def self.get_trains(user_id)
    new(user_id).determine_trains_for_user
  end

  def initialize(user_id)
    # set user_id instance var
    # establish the database connection
  end

  def determine_trains_for_user
    # go in user-train table and match user_id with train_id
    # find trains that correspond to train_id
  end

end
