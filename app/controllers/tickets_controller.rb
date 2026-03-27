class TicketsController < ApplicationController
  def index
    @tickets = current_user.tickets
    # ログイン中のユーザーのチケットを取得
  end

  def update
    ticket = current_user.tickets.find(params[:id])
    # ログイン中のユーザーのチケットから、更新するチケットを見つける
    # Viewで使わないため、インスタンス変数ではなくローカル変数で定義

    if ticket.used?
      redirect_to tickets_path, alert: "このチケットはすでに使用済みです。"
      return
    end

    if ticket.update!(ticket_params)
      respond_to do |format|
      # ブロックを使用して、条件分岐を行っている。ここではfoermatを使用して、リクエストの形式に応じたレスポンスを返すようにしている。
        format.html { redirect_to tickets_path, notice: "チケットを更新しました。" }
        format.json { render json: { status: "ok", used: ticket.used } }
      end
    else
      respond_to do |format|
        format.html { redirect_to tickets_path, alert: "チケットの更新に失敗しました。" }
        format.json { render json: { status: "error", errors: ticket.errors.full_messages }, status: :unprocessable_entity }
      end
    end
    # 見つけたユーザーのチケットを使用済みに更新
    redirect_to tickets_path, notice: "チケットを使用しました。"
    # チケット一覧にリダイレクトして、使用完了のメッセージを表示
  end

  def ticket_params
    params.require(:ticket).permit(:used)
    # ブラウザから送られてくるparamsの中からrequireでticketを指定し、その中からpermitでusedのカラムのみを許可する。これにより、悪意のあるユーザーが他の属性を更新することを防ぐ。
  end
end
