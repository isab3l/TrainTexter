class UserTrainsReader

	attr_reader :user_name, :user_trains

	def self.read_user_trains
		new.get_user_trains
	end

	def initialize
		@user_name = user_name_prompt
	  @user_trains = {}
	end

	def get_user_trains
		user_trains[user_name] = user_trains_prompt
		user_trains
	end

	private

	def user_name_prompt
		puts "Please enter user name and press ENTER."
		gets.chomp
	end

	def user_trains_prompt
		puts "Please enter the trains you would like to be notified about seperated by a comma and press ENTER."
		gets.chomp.split(',')
	end

end