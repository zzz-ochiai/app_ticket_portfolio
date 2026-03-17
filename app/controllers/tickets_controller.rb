class TicketsController < ApplicationController
  def index
    @tickets = current_user.tickets
    # ログイン中のユーザーのチケットを取得
  end

  def update
    ticket = current_user.tickets.find(params[:id])
    # ログイン中のユーザーのチケットから、更新するチケットを見つける
    # Viewで使わないため、インスタンス変数ではなくローカル変数で定義
    ticket.update!(used: true)
    # 見つけたユーザーのチケットを使用済みに更新
    redirect_to tickets_path, notice: "チケットを使用しました。"
    # チケット一覧にリダイレクトして、使用完了のメッセージを表示
  end
end
