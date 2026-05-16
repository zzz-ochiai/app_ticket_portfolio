class Admin::DashboardController < ApplicationController
  before_action :authenticate_admin!
  before_action :check_admin_status

  def index
  end

  private

  def check_admin_status
    return if current_admin.status == "approved"

    sign_out current_admin
    redirect_to new_admin_session_path, alert: "承認待ちです"
  end
end
