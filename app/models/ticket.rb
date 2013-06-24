class Ticket < ActiveRecord::Base
  attr_accessible :position, :seat, :description, :status
end
