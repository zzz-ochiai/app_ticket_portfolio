class Admin::TicketsController < Admin::BaseController
  def create
    @user = User.find(params[:user_id])
    @ticket = @user.tickets.build(used: false)

    if @ticket.save
      redirect_to admin_user_path(@user), notice: "チケットを作成しました"
    else
      redirect_to admin_user_path(@user), alert: "チケットを作成できませんでした"
    end
  end

  def destroy
    @ticket = Ticket.find(params[:id])
    @user = @ticket.user

    if @ticket.destroy
      redirect_to admin_user_path(@user), notice: "チケットを削除しました"
    else
      redirect_to admin_user_path(@user), alert: "チケットを削除できませんでした"
    end
  end

  def revert
    @ticket = Ticket.find(params[:id])

    if @ticket.update(used: false)
      redirect_to admin_user_path(@ticket.user), notice: "チケットを未使用に戻しました"
    else
      redirect_to admin_user_path(@ticket.user), alert: "チケットの状態を更新できませんでした"
    end
  end
end
