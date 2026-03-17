class Admin::UsersController < Admin::BaseController
  # ベースコントローラを継承して、ログインと管理者権限の確認を行う。
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end
end
