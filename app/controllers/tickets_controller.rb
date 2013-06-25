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

  # PUT /tickets/:id
  # PUT /tickets/:id.json
  def update
    ticket = Ticket.find(params[:id])

    if params[:status] and ticket.update_attributes(status: params[:status])
      render json: {"notice"=>"status updated successfully"}
    else
      render json: {"alert"=>"status not updated. check params."}
    end
  end
end
