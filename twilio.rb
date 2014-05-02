require_relative 'mta_status_db.rb'
require 'twilio-ruby'
require 'pg'
 
class TwilioIntegration
 
  ACCOUNT_SID = "AC49de56d245eb573da3703df2cfde338a"
  AUTH_TOKEN = "e77802c0ce3871a5cdd5da29f6eb17ad"
  FROM = "+19176526862"

  #------TO BE DELETED-------
  @receivers = {"+12127293997" => "Zach"}
  @train = "123"
  @status = "GOOD SERVICE"
  #----------------

  def self.send_message
    view_receivers.each do |phone_number, name|
      sign_in.account.messages.create(
        :from => FROM,
        :to => phone_number,
        :body => "Hey #{name}, The #{@train} is running with #{@status}!"
        )
      puts "Sent message to #{name}"
    end
  end

  # private

  def self.sign_in
    Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
  end

  def self.get_database_data
    UpdateDatabase.update_database
  end

  def self.view_receivers
    @receivers
  end

  def self.get_receivers
  end

  def self.get_name
  end

  def self.get_number
  end

  def self.get_train
  end

end

p TwilioIntegration.get_database_data.values
# TwilioIntegration.send_message