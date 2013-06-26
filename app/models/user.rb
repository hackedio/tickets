class User < ActiveRecord::Base
  attr_accessible :msisdn, :name, :group_id

  validates :group_id, :presence => true, allow_blank: false

  belongs_to :group
end
