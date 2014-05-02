require 'pg'
require 'nokogiri'
require 'open-uri'

class FileReader

	MTA_FILE = 'http://web.mta.info/status/serviceStatus.txt'
	@parsed_file = Nokogiri::XML::Document.new

	def self.read_file
		update_parsed_file(Nokogiri::XML(open(MTA_FILE)))
	end

	def self.update_line
		view_parsed_file.xpath("//name").collect do |name|
			name.children.text
		end
	end

	def self.update_status
		view_parsed_file.xpath("//status").collect do |status|
			status.children.text
		end
	end

	# private

	def self.update_parsed_file(new_file)
		@parsed_file = new_file
	end

	def self.view_parsed_file
		@parsed_file
	end

end

class StatusUpdate

	def self.get_status_update
		FileReader.read_file
		Hash[FileReader.update_line.zip FileReader.update_status]
	end

end