require 'spec_helper'

describe UsersController do
  before(:all) { 3.times { create(:user) } }

  describe "#index" do
    before { get :index, :format => :json }
    let(:body) { JSON.parse(response.body) }

    its(:status) { should be 200 }
    its(:response) { should be_success }
    specify { body.should be_kind_of Array }
    specify { body.sample.should be_kind_of Hash }
    specify { body.sample.should include("id","name","msisdn") }
  end

  after(:all) { User.destroy_all }

end
