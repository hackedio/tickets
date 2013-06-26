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
end
