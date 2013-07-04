require 'spec_helper'

describe TicketsController do
  before(:all) do
    5.times { create(:ticket) }
    3.times { create(:ticket, status: "resolved") }
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
      specify { body.sample.should include("id","name","seat","status","ticket_no","description") }

      context "with status param set to 'waiting'" do
        before { get :index, { status: "waiting", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 5 }
        specify { body.each { |i| i['status'].should eq "waiting" } }
      end

      context "with status param set to 'resolved'" do
        before { get :index, { status: "resolved", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 3 }
        specify { body.each { |i| i['status'].should eq "resolved" } }
      end
    end
  end

  describe "#show" do
    context "when correct params" do

      it "should return correct response" do
        pending # why is assigns returning nil!?!?
        t = create(:ticket)
        Ticket.should_receive(:find).with(t.id.to_s)
        get :show, { id: t.id }, :format => :json
        expect(assigns(:ticket)).to eq("something")
        t.destroy
      end
    end

    context "when incorrect params" do
      it "should show empty braces"
      # can't complete this until above test works correctly...
    end
  end

  describe "#update" do

    context "when not yet updated" do

      subject { Ticket.find(@ticket.id) }

      its(:status) { should eq "waiting" }
    end

    context "when updated" do
      before { @ticket2 = create(:ticket) }
      let(:update_request) { put :update, {id: @ticket2.id, status: "resolved"}, :format => :json  }

      subject { @ticket2.status }

      it { should eq "waiting" }
      it "should update the status record in db" do
        expect { update_request }.to change { Ticket.find(@ticket2.id).status }.to("resolved")
      end
      it "returns correct response" do
        update_request
        response.body.should include "status updated successfully to 'resolved'"
      end

      after { @ticket2.destroy }
    end

    context "when no status param sent through" do
      before { @ticket3 = create(:ticket) }
      let(:update_request) { put :update, {id: @ticket3.id}, :format => :json }

      subject { @ticket3.status }

      it { should eq "waiting" }
      it "should not update the status record in db" do
        expect { update_request }.to_not change { @ticket3.status }
      end
      it "returns correct response" do
        update_request
        response.body.should include "status not updated. check params."
      end

      after{ @ticket3.destroy }
    end
  end

  describe "#create" do
    before(:all) do
      create(:group, name:"THUNDER")
    end
    let(:valid_attributes) do
      { name: "John Smith",
        seat: "4B",
        desc: "Help with Heroku!?",
        group: "THUNDER" }
    end
    let(:blank_name) do
      { name: "",
        seat: "4B",
        desc: "Help with Heroku!?",
        group: "THUNDER"}
    end

    context "when request sent with correct data" do
      let(:create_new_ticket) do
        post :create, valid_attributes
      end
      it "should create new ticket record" do
        expect { create_new_ticket }.to change { Ticket.count }.by(1)
        Ticket.last.seat.should eq "4B"
        Ticket.last.description.should eq "Help with Heroku!?"
        Ticket.last.destroy
      end
    end

    context "when request sent with missing data" do
      let(:create_new_ticket) do
        post :create, { description: "Help with Heroku!?", group:"THUNDER"}
      end
      it "should not create new ticket record" do
        expect { create_new_ticket }.to_not change { Ticket.count }
      end
    end

    context "when request sent with blank name" do
      let(:create_new_ticket) do
        post :create, blank_name
      end
      it "should not create new ticket record" do
        expect { create_new_ticket }.to_not change { Ticket.count }
      end
    end

    context "when request has completed" do
      context "without error" do
        subject { post :create, valid_attributes, :format => :json }

        it { should redirect_to "http://hacked.io/almanac/get-help/submitted" }

        after { Ticket.last.destroy }
      end

      context "with error" do
        subject  { post :create, blank_name, :format => :json }

        it { should redirect_to "http://hacked.io/almanac/get-help/not-submitted" }
      end
    end
  end

  after(:all) do
    Ticket.destroy_all
    Group.destroy_all
  end
end
