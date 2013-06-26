class User < ActiveRecord::Base
  attr_accessible :msisdn, :name

  belongs_to :group
end
