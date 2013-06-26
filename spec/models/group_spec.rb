require 'spec_helper'

describe Group do
  before(:all) { create(:group) }

  let(:group_assigned_ticket) { Group.first.tickets.build( { msisdn: "07712345678",
                                                             seat: "4B",
                                                             description: "Help with Heroku!?" } ) }

  subject { group_assigned_ticket }

  it { should be_valid }

  after(:all) do 
    Ticket.destroy_all
    Group.destroy_all
  end
end
