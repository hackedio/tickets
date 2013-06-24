class Ticket < ActiveRecord::Base
  attr_accessible :ticket_no, :msisdn, :seat, :description, :status

  before_create :increment_ticket_no

  validates :msisdn, :seat, :description, :presence => true, allow_blank: false

  private

  def increment_ticket_no
    ticket = Ticket.last
    self.ticket_no = ticket.nil? ? 1 : ticket.ticket_no+1
  end
end
