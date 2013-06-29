class UsersController < ApplicationController

  # GET /groups/:group_id/users
  def index
    begin
      group = Group.find(params[:group_id])
      members = group.members
    rescue ActiveRecord::RecordNotFound
      members = nil
    end

    render json: members || {"alert"=>"group does not exist"}
  end

  # POST /groups/:group_id/users
  def create
    begin
      group = Group.find(params[:group_id])
      new_user = group.members.new(name:params[:name],
                                   msisdn:params[:msisdn])
    rescue ActiveRecord::RecordNotFound
      new_user = nil
    end

    if new_user and new_user.save
      render json: {"notice"=>"new user created successfully."}
    else
      render json: {"alert"=>"User was not created. Check your msisdn is valid."}
    end
  end

  # DELETE /groups/:group_id/users/:id
  def destroy
    begin
      group = Group.find(params[:group_id])
      user = group.members.find(params[:id])
      user.destroy
      render json: { "notice"=>"user deleted successfully" }
    rescue ActiveRecord::RecordNotFound
      render json: { "alert"=>"did not specify a valid id. no record deleted." }
    end
  end

  # PUT /groups/:group_id/users/:id
  def update
    begin
      group = Group.find(params[:group_id])
      user = group.members.find(params[:id])
      name = params[:name] || user.name
      msisdn = params[:msisdn] || user.msisdn

      if user.update_attributes(name:name, msisdn:msisdn)
        render json: {"notice"=>"attributes updated successfully"}
      else
        render json: {"alert"=>"attributes not updated. check params."}
      end
    rescue ActiveRecord::RecordNotFound
      render json: {"alert"=>"record does not exist. check id."}
    end
  end
end
