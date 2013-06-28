require 'spec_helper'

describe UsersController do
  before(:all) do
    @group = create(:group)
    create(:user, group_id:@group.id)
  end

  describe "#index" do
    before { get :index, { group_id:@group.id } }
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
        post :create, { group_id: @group.id, name:"John",msisdn:"07712345678" }
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
      before { post :create, {group_id:@group.id} }

      subject { response }

      its(:body) { should include "User was not created. Check your msisdn is valid." }
    end
  end

  describe "#destroy" do
      before do
        @group2 = create(:group)
        @user = create(:user, group_id:@group2.id)
      end

      it "should delete user" do
        expect{ delete :destroy, {group_id:@group2.id, id:@user.id} }.to change{ User.count }.by(-1)
      end

      context "when request correct" do
        before do
          @group2 = create(:group)
          @user = create(:user, group_id:@group2.id)
          delete :destroy, {group_id:@group2.id,id:@user.id}
        end

        subject { response }

        its(:body) { should include "user deleted successfully" }
      end

      context "when request not correct" do
        before do
          delete :destroy, {group_id:-1, id:-1}
        end

        subject { response }

        its(:body) { should include "did not specify a valid id. no record deleted." }
      end
  end

  describe "#update" do
    context "when updated" do
      before do
        @group = create(:group)
        @user = create(:user, group_id: @group.id)
      end
      let(:update_name) { put :update, {group_id: @group.id, id: @user.id, name: "something_else"}  }
      let(:update_msisdn) { put :update, {group_id: @group.id, id: @user.id, msisdn: "07711111111"}  }
      let(:update_msisdn_and_name) { put :update, {group_id: @group.id, id: @user.id, name: "another_name", msisdn:"07712121212"}  }

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
      before do
        @group = create(:group)
        @user = create(:user, group_id: @group.id)
      end
      let(:no_params) { put :update, {group_id: @group.id, id: @user.id, msisdn:"123"} }

      it "should not update the status record in db" do
        expect { no_params }.to_not change { User.find(@user.id) }
      end
      it "returns correct response" do
        no_params
        response.body.should include "attributes not updated. check params."
      end
    end

    context "when record not found" do
      before { put :update, {group_id: -1, id: -1, name: "another_name", msisdn:"07712121212"} }
      subject { response }

      its(:body) { should include "record does not exist. check id." }
    end
  end

  after(:all) { User.destroy_all }
end
