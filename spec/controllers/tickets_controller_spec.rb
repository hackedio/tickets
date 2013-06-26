require 'spec_helper'

describe TicketsController do
  before(:all) do
    5.times { create(:ticket) }
    3.times { create(:ticket, status: "pending") }
    2.times { create(:ticket, status: "complete") }
    @ticket = Ticket.first
  end

  def ticket_status
    Ticket.find(@ticket.id).status
  end

  describe "#index" do
    let(:tickets) { Ticket.all }

    context "when html" do
      before { get :index }

      its(:response) { should be_success }
      its(:status) { should be 200 }
      it { should render_template("index") }
      it "assigns @tickets" do
        expect(assigns(:tickets)).to eq(tickets)
      end
    end

    context "when json" do
      before { get :index, :format => :json }
      let(:body) { JSON.parse(response.body) }

      its(:status) { should be 200 }
      its(:response) { should be_success }
      it { should_not render_template("index") }
      specify { body.should be_kind_of Array }
      specify { body.sample.should be_kind_of Hash }
      specify { body.sample.should include("id","msisdn","seat","status","ticket_no","description") }

      context "with status param set to 'waiting'" do
        before { get :index, { status: "waiting", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 5 }
        specify { body.each { |i| i['status'].should eq "waiting" } }
      end

      context "with status param set to 'pending'" do
        before { get :index, { status: "pending", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 3 }
        specify { body.each { |i| i['status'].should eq "pending" } }
      end

      context "with status param set to 'complete'" do
        before { get :index, { status: "complete", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 2 }
        specify { body.each { |i| i['status'].should eq "complete" } }
      end
    end
  end

  describe "#update" do

    context "when not yet updated" do

      subject { Ticket.find(@ticket.id) }

      its(:status) { should eq "waiting" }
    end

    context "when updated" do
      let(:update_request) { put :update, {id: @ticket.id, status: "resolved"}, :format => :json  }

      subject { ticket_status }

      it { should eq "waiting" }
      it "should update the status record in db" do
        expect { update_request }.to change { ticket_status }.to("resolved")
      end
      it "returns correct response" do
        update_request
        response.body.should include "status updated successfully to 'resolved'"
      end
    end

    context "when no status param sent through" do
      let(:update_request) { put :update, {id: @ticket.id}, :format => :json }

      subject { ticket_status }

      it { should eq "waiting" }
      it "should update the status record in db" do
        expect { update_request }.to_not change { ticket_status }
      end
      it "returns correct response" do
        update_request
        response.body.should include "status not updated. check params."
      end
    end
  end

  describe "#create" do
    let(:valid_attributes) do
      { new_ticket: { msisdn: "07712345678",
                      seat: "4B",
                      description: "Help with Heroku!?",
                      group_id: "1"} }
    end
    let(:invalid_msisdn) do
      { new_ticket: { msisdn: "0771234567",
                      seat: "4B",
                      description: "Help with Heroku!?",
                      group_id: "1"} }
    end

    context "when request sent with correct data" do
      let(:create_new_ticket) do
        post :create, valid_attributes, :format => :json
      end
      it "should create new ticket record" do
        expect { create_new_ticket }.to change { Ticket.count }.by(1)
        Ticket.last.seat.should eq "4B"
        Ticket.last.description.should eq "Help with Heroku!?"
      end
    end

    context "when request sent with missing data" do
      let(:create_new_ticket) do
        post :create, { new_ticket: { description: "Help with Heroku!?"} }, :format => :json
      end
      it "should not create new ticket record" do
        expect { create_new_ticket }.to_not change { Ticket.count }
      end
    end

    context "when request sent with invalid msisdn" do
      let(:create_new_ticket) do
        post :create, invalid_msisdn, :format => :json
      end
      it "should not create new ticket record" do
        expect { create_new_ticket }.to_not change { Ticket.count }
      end
    end

    context "when request has completed" do
      context "without error" do
        before { post :create, valid_attributes, :format => :json }

        subject { response }

        its(:body) { should include "new ticket created successfully." }
      end

      context "with error" do
        before { post :create, invalid_msisdn, :format => :json }

        subject { response }

        its(:body) { should include "ticket was not created. check your params." }
      end
    end
  end

  after(:all) do
    Ticket.destroy_all
    Group.destroy_all
  end
end
