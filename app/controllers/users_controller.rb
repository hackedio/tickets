class UsersController < ApplicationController

  # GET /users
  # GET /users.json
  def index
    users = User.all

    render json: users
  end
end
