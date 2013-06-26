class TicketsController < ApplicationController
  # GET /tickets
  # GET /tickets.json
  def index
    if params[:status]
      @tickets = Ticket.where(status: params[:status])
    else
      @tickets = Ticket.all
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @tickets }
    end
  end

  # POST /tickets
  # POST /tickets.json
  def create
    new_ticket = Ticket.new(params[:new_ticket]) # name form "new_ticket"

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
