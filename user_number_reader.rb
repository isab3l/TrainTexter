class UserNumberReader

	attr_reader :user_name, :user_phone

	def self.read_user_number
		new.get_user_phone
	end


	def initialize
		@user_name = user_name_prompt
	  @user_phone = {}
	end

	def get_user_phone
		user_phone[user_name] = "+1#{user_number_prompt}"
		user_phone
	end

	private

	def user_name_prompt
		puts "Please enter user name and press ENTER."
		gets.chomp
	end

	def user_number_prompt
		puts "Please enter user number and press ENTER."
		gets.chomp
	end

end