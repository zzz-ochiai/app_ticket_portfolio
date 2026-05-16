class OldAdmin::TicketsController < OldAdmin::BaseController
  def index
    @user = User.find(params[:user_id])
    @tickets = @user.tickets
  end

  def revert
    @ticket =Ticket.find(params[:id])

    if @ticket.update!(used: false)
      redirect_to old_admin_user_path(@ticket.user), notice: "チケットを未使用に戻しました"
    else
      redirect_to old_admin_user_path(@ticket.user), alert: "チケットの状態を更新できませんでした"
    end
  end
end
