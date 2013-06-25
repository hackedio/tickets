require 'spec_helper'

describe Ticket do
  context "when creating new record" do

    before { 2.times { create(:ticket) } }

    subject { Ticket.last }

    its(:ticket_no) { should eq Ticket.first.ticket_no+1 }

    its(:status) { should eq "waiting" }

    it "creates record successfully if all fields are valid" do
      expect { create(:ticket) }.to change { Ticket.count }.by(1)
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

end
