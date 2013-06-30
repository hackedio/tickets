class TicketsController < ApplicationController
  # GET /tickets
  # GET /tickets.json
  def index
    if params[:status]
      @tickets = Ticket.where(status: params[:status])
    else
      @tickets = Ticket.all
      @tickets_waiting = Ticket.where(status:"waiting")
      @tickets_resolved = Ticket.where(status:"resolved")
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tickets }
    end
  end

  # GET /tickets/:id
  # GET /tickets/:id.json
  def show
    @ticket = Ticket.find(params[:id])
    respond_to do |format|
      format.html
      format.json { render json: @ticket }
    end
  end

  # POST /tickets
  # POST /tickets.json
  def create
    name = params[:name]
    seat = params[:seat]
    desc = params[:desc]
    group_name = params[:group]
    group = Group.where(name:group_name).first

    new_ticket = group.tickets.new(name:name,seat:seat,description:desc)

    if new_ticket.save
      render json: {"notice"=>"new ticket created successfully."}
    else
      render json: {"alert"=>"ticket was not created. check your params."}
    end
  end

  # PUT /tickets/:id
  # PUT /tickets/:id.json
  def update
    ticket = Ticket.find(params[:id])
    status = params[:status]

    if status and ticket.update_attributes(status: status)
      render json: {"notice"=>"status updated successfully to '#{status}'"}
    else
      render json: {"alert"=>"status not updated. check params."}
    end
  end
end
