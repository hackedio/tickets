require 'spec_helper'

describe Ticket do

  context "with group association" do
    before do
      @group = create(:group, name:"geeks")
      @ticket = create(:ticket, group_id: @group.id)
    end

    subject { @ticket.group }

    it { should be_valid }
    its(:name) { should eq "geeks" }
  end

  context "when creating new record" do
    before do
      create(:group)
      @ticket1 = create(:ticket)
      @ticket2 = create(:ticket)
    end

    subject { @ticket2 }

    its(:ticket_no) { should eq @ticket1.ticket_no+1 }

    its(:status) { should eq "waiting" }

    it "creates record successfully if all fields are valid" do
      expect { create(:ticket) }.to change { Ticket.count }.by(1)
    end

    it "raises a RecordInvalid error if all fields are blank" do
      expect do
        create(:ticket, name:"", seat:"", description:"")
      end.to raise_error ActiveRecord::RecordInvalid
    end

    context "without group_id" do
      it "raises a RecordInvalid error" do
        expect { create(:ticket, group_id: nil) }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    it "raises error if name field is blank" do
      expect { create(:ticket, name: "") }.to raise_error ActiveRecord::RecordInvalid
    end

    it "raises a RecordInvalid error if seat field is blank" do
      expect { create(:ticket, seat: "") }.to raise_error ActiveRecord::RecordInvalid
    end

    it "raises a RecordInvalid error if description field is blank" do
      expect { create(:ticket, description: "") }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  after(:all) { Ticket.destroy_all }
end
