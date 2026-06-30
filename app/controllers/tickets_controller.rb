class TicketsController < ApplicationController
  before_action :authenticate_user!

  def index
    @tickets = current_user.tickets
  end

  def update
    @ticket = current_user.tickets.find(params[:id])
    client_updated_at = Time.parse(params[:updated_at])

    # 更新時間による競合制御
    if client_updated_at > @ticket.updated_at
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

# ＜学習メモ＞
# TimeはRubyのクラスであり、返り値はTimeオブジェクト
# Time.parseメソッドは引数をTimeオブジェクトに変換する
# JSONとして渡す際にキー（error: など）はJSでプロパティとして再利用ができる
# paramsはHTTPメソッド、URL、ヘッダー、bodyをまとめたリクエスト情報である
# paramsはキーのネスト構造をとることがあり、.require()では引数のキーの中身を指定している
# （？）paramsのネスト構造を作るのはフォーム⇒フォームとキーについて詳しく調べる
