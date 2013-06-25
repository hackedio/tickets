require 'spec_helper'

describe TicketsController do

  describe "GET index" do

    let(:ticket) { create(:ticket) }
    before { ticket }

    context "when html" do
      before { get :index }

      its(:response) { should be_success }
      its(:status) { should be 200 }
      it { should render_template("index") }
      it "assigns @tickets" do
        expect(assigns(:tickets)).to eq([ticket])
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
    end
  end
end
