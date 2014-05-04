require 'twilio-ruby'

class SendUserNotification

  attr_reader :name, :phone, :train, :status

  ACCOUNT_SID = "AC49de56d245eb573da3703df2cfde338a"
  AUTH_TOKEN = "e77802c0ce3871a5cdd5da29f6eb17ad"
  FROM = "+19176526862"

  def self.new_message(name, phone, train, status)
    new(name, phone, train, status).send_message
  end

  def initialize(name, phone, train, status)
    @name = name
    @phone = phone
    @train = train
    @status = status
  end

  def send_message
      sign_in.account.messages.create(
        :from => FROM,
        :to => phone,
        :body => create_body
        )
  end

  private

  def sign_in
    Twilio::REST::Client.new ACCOUNT_SID, AUTH_TOKEN
  end

  def create_body
    "Hey #{name}, The #{train} is running with #{status}!"
  end

end
