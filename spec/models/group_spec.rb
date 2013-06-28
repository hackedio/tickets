require 'spec_helper'

describe Group do

  context "when associating tickets" do
    before(:all) { create(:group) }

    let(:group_assigned_ticket) { Group.first.tickets.build( { msisdn: "07712345678",
                                                               seat: "4B",
                                                               description: "Help with Heroku!?" } ) }

    subject { group_assigned_ticket }

    it { should be_valid }
  end

  context "when associating users" do
    before(:all) { create(:group) }

    let(:group_assigned_users) { Group.first.members.build( { name:"john", msisdn:"07812345678" } ) }

    subject { group_assigned_users }

    it { should be_valid }
  end

  after(:all) do 
    Ticket.destroy_all
    Group.destroy_all
  end
end
