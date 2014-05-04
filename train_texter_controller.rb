require_relative 'user_table_update.rb'
require_relative 'notification_times_table_update.rb'
require_relative 'trains_table_update.rb'
require_relative 'users_trains_table_update'
require_relative 'users_times_table_update'
require_relative 'user_train_manager.rb'

class TrainTexterController
  def self.execute
    update_databases
    UserTrainManager.send_message
  end

  def self.update_databases
    UsersTableUpdate.update!
    NotificationTimesTableUpdate.update!
    TrainsTableUpdate.update!
    UsersTrainsTableUpdate.update!
    UsersTimesTableUpdate.update!
  end
end

TrainTexterController.execute
