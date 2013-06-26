class Ticket < ActiveRecord::Base
  attr_accessible :ticket_no, :msisdn, :seat, :description, :status

  before_create :increment_ticket_no

  validates :seat, :description, :presence => true, allow_blank: false
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
end
