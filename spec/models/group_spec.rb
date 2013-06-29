require 'spec_helper'

describe Group do
  before(:all) { create(:group) }

  context "when associating tickets" do
    let(:group_assigned_ticket) { Group.first.tickets.build( { name: "John Doe",
                                                               seat: "4B",
                                                               description: "Help with Heroku!?" } ) }

    subject { group_assigned_ticket }

    it { should be_valid }
  end

  context "when associating users" do
    let(:group_assigned_users) { Group.first.members.build( { name:"john", msisdn:"07812345678" } ) }

    subject { group_assigned_users }

    it { should be_valid }
  end

  context "when group is destroyed" do
    before do
      @group = create(:group)
      @user1 = create(:user, group_id:@group.id)
      @user2 = create(:user, group_id:@group.id)
    end
    it "destroys any members associated with it" do
      expect{ @group.destroy }.to change{ User.count }.by(-2)
    end
  end

  after(:all) do 
    Ticket.destroy_all
    Group.destroy_all
  end
end
