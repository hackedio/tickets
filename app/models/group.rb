class Group < ActiveRecord::Base
  attr_accessible :name

  validates :name, :presence => true, allow_blank: false

  has_many :tickets
  has_many :members, :class_name => "User", :dependent => :destroy
end
