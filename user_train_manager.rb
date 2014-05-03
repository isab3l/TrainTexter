
class UserTrainManager

  attr_reader :users

  def initialize
    @users = UserRetriever.get_users
  end

  def get_user_trains
    users.each do |user|
      trains = TrainRetriever.get_trains(user.first)
      send_status_notification(user, trains)
    end
  end

  def send_status_notifictation(user, trains = [])

  end

end
