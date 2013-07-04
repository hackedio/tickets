class GroupsController < ApplicationController
  before_filter :authenticate, :except => [:create, :destroy, :update] unless Rails.env == "test"

  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.all

    respond_to do |format|
      format.html
      format.json { render json: @groups }
    end
  end

  # GET /groups:id
  # GET /groups/:id.json
  def show
    group = Group.find(params[:id])

    render json: group
  end

  # POST /groups
  # POST /groups.json
  def create
    new_group = Group.new(name: params[:name])

    if new_group.save
      render json: { "notice"=>"new group #{params[:name]} successfully created" }
    else
      render json: { "alert"=>"group creation failed. check params." }
    end
  end

  # DELETE /groups/:id
  # DELETE /groups/:id.json
  def destroy
    begin
      group = Group.find(params[:id])
      group.destroy
      render json: { "notice"=>"group deleted successfully" }
    rescue ActiveRecord::RecordNotFound
      render json: { "alert"=>"did not specify a valid id. no record deleted." }
    end
  end

  # PUT /groups/:id
  # PUT /groups/:id.json
  def update
    begin
      group = Group.find(params[:id])
      if params[:name] and group.update_attributes(name: params[:name])
        render json: { "notice"=>"group name updated to #{params[:name]}" }
      else
        render json: { "alert"=>"record not updated. check your params." }
      end
    rescue ActiveRecord::RecordNotFound
      render json: { "alert"=>"did not specify a valid id. no record updated." }
    end
  end
end

