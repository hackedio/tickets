class Ticket < ActiveRecord::Base
  attr_accessible :ticket_no, :msisdn, :seat, :description, :status, :group_id

  belongs_to :group

  before_create :increment_ticket_no
  after_create :send_sms_to_group unless Rails.env == 'test'

  validates :seat, :description, :group_id, :presence => true, allow_blank: false
  validate :valid_msisdn

  private

  def increment_ticket_no
    ticket = Ticket.last
    self.ticket_no = ticket.nil? ? 1 : ticket.ticket_no+1
  end

  def valid_msisdn
    errors.add(:msisdn, "not valid msisdn") unless msisdn_is_valid?(self.msisdn)
  end

  def msisdn_is_valid?(msisdn)
    unless msisdn.nil?
      msisdn.sub!('0','44')
      msisdn_regex = /\A(([4][4][7][4-5|7-9])(\d{8}))\Z/
      return msisdn.match(msisdn_regex)
    end
    false
  end

  def send_sms_to_group
    account_sid = ENV['TWILIO_ACCOUNT_SID']
    auth_token  = ENV['TWILIO_AUTH_TOKEN']
    client = Twilio::REST::Client.new(account_sid, auth_token)

    account = client.account
    self.group.members.each do |member|
      link = "http://www.example.com/tickets/#{self.id}"
      msg = account.sms.messages.create({:from => ENV['TWILIO_HACKED_NO'], :to => member.msisdn, :body => "##{self.ticket_no} - #{self.seat} - #{link}"})
      puts "sent sms to #{member.name}"
      puts "response -> #{msg}"
    end
  end
end
