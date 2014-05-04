require 'nokogiri'
require 'open-uri'

class TrainFileReader

	attr_reader :parsed_file

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

	private

	def read_file
		update_parsed_file(Nokogiri::XML(open(MTA_FILE)))
	end

	def update_line
		parsed_file.xpath("//name").collect do |name|
			name.children.text
		end
	end

	def update_status
		parsed_file.xpath("//status").collect do |status|
			status.children.text
		end
	end

	def update_parsed_file(new_file)
		@parsed_file = new_file
	end

end
