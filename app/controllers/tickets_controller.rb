class TicketsController < ApplicationController
  def index
    @tickets = current_user.tickets
    # ログイン中のユーザーのチケットを取得
  end
end
