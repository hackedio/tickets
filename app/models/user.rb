class User < ActiveRecord::Base
  attr_accessible :msisdn, :name, :group_id

  validates :group_id, :presence => true, allow_blank: false
  validate :valid_msisdn

  belongs_to :group

  private

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
