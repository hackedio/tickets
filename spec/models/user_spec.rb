require 'spec_helper'

describe User do

  context "with group association" do
    before(:all) do
      group = create(:group, name:"geeks")
      @user = create(:user, group_id: group.id)
    end

    subject { @user.group }

    its(:name) { should eq "geeks" }
  end

  context "with group-ticket association" do
    before(:all) do
      group = create(:group, name:"geeks")
      @ticket = create(:ticket, group_id: group.id)
      @user = create(:user, group_id: group.id)
    end

    subject { @user.group.tickets }

    it { should be_kind_of Array }
    its(:count) { should eq 1 }
    its(:'first.id') { should eq @ticket.id}

  end

  context "without group_id" do
    it "should_not be_valid" do
      expect{ create(:user, group_id: nil) }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  after(:all) do
    Group.destroy_all
    User.destroy_all
    Ticket.destroy_all
  end
end
