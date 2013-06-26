class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    users = User.all

    render json: users
  end

  # POST /users
  # POST /users.json
  def create
    new_user = User.new(params[:new_user])

    if new_user.save
      render json: {"notice"=>"new user created successfully."}
    else
      render json: {"alert"=>"user was not created. check your params."}
    end
  end

  # DELETE /users/:id
  # DELETE /users/:id.json
  def destroy
    begin
      user = User.find(params[:id])
      user.destroy
      render json: { "notice"=>"user deleted successfully" }
    rescue ActiveRecord::RecordNotFound
      render json: { "alert"=>"did not specify a valid id. no record deleted." }
    end
  end

  # PUT /users/:id
  # PUT /users/:id.json
  def update
    user = User.find(params[:id])
    name = params[:name] || user.name
    msisdn = params[:msisdn] || user.msisdn

    if user.update_attributes(name:name, msisdn:msisdn)
      render json: {"notice"=>"attributes updated successfully"}
    else
      render json: {"alert"=>"attributes not updated. check params."}
    end
  end
end
