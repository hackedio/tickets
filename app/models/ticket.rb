class Ticket < ActiveRecord::Base
  attr_accessible :ticket_no, :msisdn, :seat, :description, :status, :group_id

  belongs_to :group

  before_create :increment_ticket_no
  # after_create :send_sms_to_group

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
    self.ticket.group.members
    message = account.sms.messages.create({:from => '+442033222431', :to => '447812454885', :body => 'Hey, this working?'})
    message2 = account.sms.messages.create({:from => '+442033222431', :to => '447718188620', :body => 'Hey, this working?'})
    puts message
  end
end
