require_relative = 'user_retriever.rb'
require_relative = 'train_retriever.rb'
require_relative = 'send_user_notification.rb'


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

  def send_status_notifictation(user, train, status)
    SendUserNotification.new_message(user, train, status)
  end

end
