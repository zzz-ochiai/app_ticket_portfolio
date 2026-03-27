class TicketsController < ApplicationController
  def index
    @tickets = current_user.tickets
    # ログイン中のユーザーのチケットを取得
  end

  def update
    @ticket = current_user.tickets.find(params[:id])

    if @ticket.used?
      redirect_to tickets_path, alert: "このチケットはすでに使用済みです"
      return
    end

    respond_to do |format|
      if @ticket.update(used: true)
        format.html { redirect_to tickets_path, notice: "チケットを使用済みにしました" }
        format.json { render json: { status: "ok", ticket: @ticket } }
      else
        format.html { render :index, status: :unprocessable_entity }
        format.json { render json: { errors: @ticket.errors.full_messages }, status: :unprocessable_entity }
      end
    end
  end
end