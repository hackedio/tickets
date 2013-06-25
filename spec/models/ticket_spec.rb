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
      expect do
        create(:ticket, msisdn:"", seat:"", description:"")
      end.to raise_error ActiveRecord::RecordInvalid
    end

    context "with invalid msisdn field" do
      it "raises a RecordInvalid error if msisdn field is blank" do
        expect { create(:ticket, msisdn: "") }.to raise_error ActiveRecord::RecordInvalid
      end

      it "raises a RecordInvalid error if msisdn is too few characters" do
        expect { create(:ticket, msisdn: "44781234567") }.to raise_error ActiveRecord::RecordInvalid
      end

      it "raises a RecordInvalid error if msisdn is too many characters" do
        expect { create(:ticket, msisdn: "4478123456789") }.to raise_error ActiveRecord::RecordInvalid
      end

      it "raises a RecordInvalid error if msisdn is wrong type of characters" do
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

  after(:all) { Ticket.destroy_all }
end
