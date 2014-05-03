require 'pg'
require 'nokogiri'
require 'open-uri'

class FileReader

	MTA_FILE = 'http://web.mta.info/status/serviceStatus.txt'

	def self.parse
		new.parse_file
	end

	def initialize
	  @parsed_file = Nokogiri::XML::Document.new
	end

	def parse_file
		read_file
		Hash[update_line.zip update_status]
	end

	def read_file
		update_parsed_file(Nokogiri::XML(open(MTA_FILE)))
	end

	def update_line
		view_parsed_file.xpath("//name").collect do |name|
			name.children.text
		end
	end

	def update_status
		view_parsed_file.xpath("//status").collect do |status|
			status.children.text
		end
	end

	private

	def update_parsed_file(new_file)
		@parsed_file = new_file
	end

	def view_parsed_file
		@parsed_file
	end

end
