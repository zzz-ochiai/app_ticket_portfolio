class OldAdmin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin!
  # 管理者専用のコントローラーで、ユーザーが管理者であることを確認するためのbefore_actionを追加。

  private

  def require_admin!
    redirect_to root_path, alert: "権限がありません" unless current_user.admin?
  end
end
