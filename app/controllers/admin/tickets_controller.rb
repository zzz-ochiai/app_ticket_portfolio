class Admin::TicketsController < Admin::BaseController
  def index
    @user = User.find(params[:user_id])
    @tickets = @user.tickets
  end

  def revert
    @ticket =Ticket.find(params[:id])
    @ticket.update!(used: false)

    redirect_to admin_user_tickets_path(@ticket.user), notice: "チケットを未使用に戻しました"
  end
end
