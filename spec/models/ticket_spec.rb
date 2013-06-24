require 'spec_helper'

describe Ticket do
  context "when creating new record" do
    it "creates record successfully if all fields are valid" do
      expect { create(:ticket) }.to_not raise_error ActiveRecord::RecordInvalid
    end

    it "raises a RecordInvalid error if all fields are blank" do
      expect { create(:ticket_blank_fields) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "raises a RecordInvalid error if msisdn field is blank" do
      expect { create(:ticket_blank_msisdn) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "raises a RecordInvalid error if seat field is blank" do
      expect { create(:ticket_blank_seat) }.to raise_error ActiveRecord::RecordInvalid
    end

    it "raises a RecordInvalid error if description field is blank" do
      expect { create(:ticket_blank_description) }.to raise_error ActiveRecord::RecordInvalid
    end
  end

  context "when new record is created" do
    its(:status) { should eq "waiting" }
  end

  context "with creation of record, ticket_no is +1 of last ticket_no" do
    before { (1..2).each { create(:ticket) } } # create two ticket records
    subject { Ticket.last }
    its(:ticket_no) { should eq Ticket.first.ticket_no+1 }
  end

end
