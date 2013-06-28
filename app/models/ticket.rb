class Ticket < ActiveRecord::Base
  attr_accessible :ticket_no, :name, :seat, :description, :status, :group_id

  belongs_to :group

  before_create :increment_ticket_no
  after_create :send_sms_to_group unless Rails.env == 'test'

  validates :seat, :description, :group_id, :name, :presence => true, allow_blank: false

  private

  def increment_ticket_no
    ticket = Ticket.last
    self.ticket_no = ticket.nil? ? 1 : ticket.ticket_no+1
  end

  def send_sms_to_group
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    client = Twilio::REST::Client.new(account_sid, auth_token)

    account = client.account
    self.group.members.each do |member|
      link = "#{ENV['HACKED_HELP_TICKET_URL']}/tickets/#{self.id}"
      msg = account.sms.messages.create({:from => ENV['TWILIO_HACKED_NO'], :to => member.msisdn, :body => "\##{self.ticket_no} - #{self.name} - #{self.seat} - #{link}"})
      puts "sent sms to #{member.name}"
      puts "response -> #{msg}"
    end
  end
end
