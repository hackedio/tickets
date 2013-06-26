require 'spec_helper'

describe GroupsController do
  before(:all) { 2.times { create(:group) } }

  describe "#index" do
    let(:groups) { Group.all }

    context "when json" do
      before { get :index, :format => :json }
      let(:body) { JSON.parse(response.body) }

      its(:status) { should be 200 }
      its(:response) { should be_success }
      specify { body.should be_kind_of Array }
      specify { body.sample.should be_kind_of Hash }
      specify { body.sample.should include("id","name") }
    end
  end

  describe "#create" do
    context "when correct params sent through" do
      let(:create_new_group) { post :create, {name: "geeks"}, :format => :json }

      it "should create new group" do
        expect{ create_new_group }.to change{ Group.count }.by(1)
      end
    end

    context "when incorrect params sent through" do
      let(:create_new_group1) { post :create, {name: ""}, :format => :json }
      let(:create_new_group2) { post :create, {name: nil}, :format => :json }

      it "should not create new group" do
        expect{ create_new_group1 }.to_not change{ Group.count }
        expect{ create_new_group2 }.to_not change{ Group.count }
      end
    end
  end

  describe "#destroy" do
    before { @group = create(:group) }
    let(:destroy) { delete :destroy, {id: @group.id}, :format => :json }
    let(:destroy_no_id) { delete :destroy, {id: ""}, :format => :json }

    it "deletes record" do
      expect{ destroy }.to change{ Group.count }.by(-1)
    end

    context "when successful" do
      before do
        group = create(:group)
        delete :destroy, {id: group.id}, :format => :json
      end

      subject { response }
      its(:body) { should include "group deleted successfully" }
    end

    context "when not successful" do
      before do
        group = create(:group)
        delete :destroy, {id: ""}, :format => :json
      end

      it "deletes no records" do
        expect{ destroy_no_id }.to_not change{ Group.count }
      end

      subject { response }
      its(:body) { should include "did not specify a valid id. no record deleted." }
    end
  end

  describe "#update" do

    context "when successful" do
      before { @g = create(:group) }
      let(:update) { put :update, {id: @g.id, name: "new_name"}, :format => :json }

      it "updates record" do
        expect{ update }.to change{ Group.find(@g.id).name }.to("new_name")
      end

      it "response body should say updated successfully" do
        put :update, {id: @g.id, name: "new_name"}, :format => :json
        response.body.should include "group name updated to new_name"
      end
    end

    context "when not successful" do
      before { @g = create(:group) }
      let(:update_no_id) { put :update, {id: "", name: "new_name"}, :format => :json }
      let(:update_invalid_id) { put :update, {id: 99999, name: "new_name"}, :format => :json }
      let(:update_no_name) { put :update, {id: @g.id, name: ""}, :format => :json }

      it "does not update record" do
        expect{ update_no_id }.to_not change{ Group.find(@g.id).name }.to("new_name")
        expect{ update_no_name }.to_not change{ Group.find(@g.id).name }.to("new_name")
      end

      context "with no id" do
        before { update_no_id }

        subject { response }

        its(:body) { should include "did not specify a valid id. no record updated." }
      end

      context "with invalid id" do
        before { update_invalid_id }

        subject { response }

        its(:body) { should include "did not specify a valid id. no record updated." }
      end

      context "with no name" do
        before { update_no_name }

        subject { response }

        its(:body) { should include "record not updated. check your params." }
      end
    end
  end

  after(:all) do
    Group.destroy_all
  end
end
