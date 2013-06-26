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

  describe "#create" do
    context "with correct params" do
      let(:request_to_create_user) do
        post :create, {new_user:{name:"John",msisdn:"07712345678",group_id: 1}}, :format => :json
      end

      it "creates new user" do
        expect{ request_to_create_user }.to change{ User.count }.by(1)
      end

      it "should give correct response in body" do
        request_to_create_user
        response.body.should include "new user created successfully."
      end
    end

    context "without correct params" do
      before { post :create, {}, :format => :json }

      subject { response }

      its(:body) { should include "user was not created. check your params." }
    end
  end

  describe "#destroy" do
      before { @user = create(:user) }

      it "should delete user" do
        expect{ delete :destroy, {id:@user.id} }.to change{ User.count }.by(-1)
      end

      context "when request correct" do
        before do
          @user = create(:user)
          delete :destroy, {id:@user.id}
        end

        subject { response }

        its(:body) { should include "user deleted successfully" }
      end

      context "when request not correct" do
        before do
          @user = create(:user)
          delete :destroy, {id:-1}
        end

        subject { response }

        its(:body) { should include "did not specify a valid id. no record deleted." }
      end

  end

  after(:all) { User.destroy_all }

end
