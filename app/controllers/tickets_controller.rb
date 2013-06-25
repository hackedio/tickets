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
end
