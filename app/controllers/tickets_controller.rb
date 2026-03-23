class TicketsController < ApplicationController
  def index
    @tickets = current_user.tickets
    # ログイン中のユーザーのチケットを取得
  end

  def update
    @ticket = current_user.tickets.find(params[:id])

    client_time = Time.parse(params[:updated_at])

    if client_time > @ticket.updated_at
      @ticket.update(ticket_params)
      render json: @ticket
    else
      render json: { error: "古い更新です" }, status: :conflict
    end
  end

  private

  def ticket_params
    params.require(:ticket).permit(:used)
  end
end
