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
    before { create(:group) }
    before { 2.times { create(:ticket) } }

    subject { Ticket.last }

    its(:ticket_no) { should eq Ticket.first.ticket_no+1 }

    its(:status) { should eq "waiting" }

    it "creates record successfully if all fields are valid" do
      expect { create(:ticket) }.to change { Ticket.count }.by(1)
    end

    it "raises a RecordInvalid error if all fields are blank" do
      expect do
        create(:ticket, msisdn:"", seat:"", description:"")
      end.to raise_error ActiveRecord::RecordInvalid
    end

    context "without group_id" do
      it "raises a RecordInvalid error" do
        expect { create(:ticket, group_id: nil) }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context "with invalid msisdn field" do
      it "raises error if msisdn field is blank" do
        expect { create(:ticket, msisdn: "") }.to raise_error ActiveRecord::RecordInvalid
      end

      it "raises error if msisdn is too few characters" do
        expect { create(:ticket, msisdn: "44781234567") }.to raise_error ActiveRecord::RecordInvalid
      end

      it "raises error if msisdn is too many characters" do
        expect { create(:ticket, msisdn: "4478123456789") }.to raise_error ActiveRecord::RecordInvalid
      end

      it "raises error if msisdn is wrong type of characters" do
        expect { create(:ticket, msisdn: "12345678910") }.to raise_error ActiveRecord::RecordInvalid
        expect { create(:ticket, msisdn: "wrongcharacters") }.to raise_error ActiveRecord::RecordInvalid
      end
    end

    context "with valid msisdn field starting with 0" do
      subject { create(:ticket, msisdn: "07812345678") }
      its(:msisdn) { should eq "447812345678" }
    end

    it "raises a RecordInvalid error if seat field is blank" do
      expect { create(:ticket, seat: "") }.to raise_error ActiveRecord::RecordInvalid
    end

    it "raises a RecordInvalid error if description field is blank" do
      expect { create(:ticket, description: "") }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context "after create" do
    it "should send a text message to all members of group" do
      pending
    end
  end

  after(:all) { Ticket.destroy_all }
end
