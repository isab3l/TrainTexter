require_relative 'user_retriever.rb'
require_relative 'train_retriever.rb'
require_relative 'send_user_notification.rb'

class UserTrainManager

  attr_reader :users

  def self.send_message
    new.compose_message
  end

  def initialize
    @users = UserRetriever.get_users.values
  end

  def compose_message
    users.each do |user|
      get_user_trains(user).each do |train|
        send_status_notification(user[1], user[2], train[0], train[1])
      end
    end
  end

  private

  def get_user_trains(user)
    TrainRetriever.get_trains(user.first).values
  end

  def send_status_notification(name, phone, train, status)
    SendUserNotification.new_message(name, phone, train, status)
  end

end



