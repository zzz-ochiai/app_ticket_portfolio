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

  def mark_used
    @ticket = Ticket.find(params[:id])

    if @ticket.update(used: true)
      redirect_to admin_user_path(@ticket.user), notice: "チケットを使用済みにしました"
    else
      redirect_to admin_user_path(@ticket.user), alert: "チケットの状態を更新できませんでした"
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

# ＜学習メモ＞
# updateメソッドはActiveRecordで定義されており、以下３つの処理がまとめられている
# @ticket.update(used: true)の場合
# （１）@ticketのused:キーの状態をtrueに変更
# （２）データベースへ保存
# （３）以上の操作が成功ならtrue、失敗ならfalseを返す
# seveメソッドも同様にデータベースへ保存し、作が成功ならtrue、失敗ならfalseを返す
# destroyメソッドのみ返り値は成功でも失敗でも削除したメソッドが返り値となる、そのため成功の判別のためにはdestroyed?を使う
# redirect_toメソッドの第２引数ではいくつかのオプションを渡せる、notice:では通知メッセージを渡す
# ⇒渡されたメッセージはflash[:notice] = "メッセージ"として一時的に保存され、遷移先のViewで表示させることができるようになる
