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

  describe "#update" do
    context "when updated" do
      before { @user = create(:user) }
      let(:update_name) { put :update, {id: @user.id, name: "something_else"}  }
      let(:update_msisdn) { put :update, {id: @user.id, msisdn: "07711111111"}  }
      let(:update_msisdn_and_name) { put :update, {id: @user.id, name: "another_name", msisdn:"07712121212"}  }

      it "should update the status record in db" do
        expect { update_name }.to change { User.find(@user.id).name }.to("something_else")
        expect { update_msisdn }.to change { User.find(@user.id).msisdn }.to("447711111111")
        update_msisdn_and_name
        User.find(@user.id).msisdn.should eq "447712121212"
        User.find(@user.id).name.should eq "another_name"
      end
      it "returns correct response" do
        update_msisdn_and_name
        response.body.should include "attributes updated successfully"
      end
    end

    context "when incorrect params sent through" do
      before { @user = create(:user) }
      let(:no_params) { put :update, {id: @user.id, msisdn:"123"}, :format => :json }

      it "should not update the status record in db" do
        expect { no_params }.to_not change { User.find(@user.id) }
      end
      it "returns correct response" do
        no_params
        response.body.should include "attributes not updated. check params."
      end
    end
  end

  after(:all) { User.destroy_all }
end
