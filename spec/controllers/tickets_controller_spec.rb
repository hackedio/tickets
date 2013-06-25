require 'spec_helper'

describe TicketsController do

  describe "GET index" do

    before do
      5.times { create(:ticket) }
      3.times { create(:ticket, status: "pending") }
      2.times { create(:ticket, status: "complete") }
    end
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
      it { body.should be_kind_of Array }
      it { body.sample.should be_kind_of Hash }
      it { body.sample.should include("id","msisdn","seat","status","ticket_no","description") }

      context "with status param set to 'waiting'" do
        before { get :index, { status: "waiting", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 5 }
        it { body.each { |i| i['status'].should eq "waiting" } }
      end

      context "with status param set to 'pending'" do
        before { get :index, { status: "pending", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 3 }
        it { body.each { |i| i['status'].should eq "pending" } }
      end

      context "with status param set to 'complete'" do
        before { get :index, { status: "complete", :format => :json } }
        let(:body) { JSON.parse(response.body) }

        subject { body }

        its(:count) { should eq 2 }
        it { body.each { |i| i['status'].should eq "complete" } }
      end
    end
  end
end
