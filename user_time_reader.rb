class UserTimeReader

	attr_reader :user_name, :user_notification_times

	def self.read_user_notifcation_times
		new.get_user_notifcation_times
	end

	def initialize
		@user_name = user_name_prompt
	  @user_notification_times = {}
	end

	def get_user_notifcation_times
		user_notification_times[user_name] = user_notification_prompt
		user_notification_times
	end

	private

	def user_name_prompt
		puts "Please enter user name and press ENTER."
		gets.chomp
	end

	def user_notification_prompt
		puts "Please enter the times you would like to be notified seperated by a comma and press ENTER."
		gets.chomp.split(',')
	end

end