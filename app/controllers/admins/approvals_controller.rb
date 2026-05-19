class Admins::ApprovalsController < ApplicationController
  def show
    admin = Admin.find_by(approval_token: params[:token])

    if admin
      admin.update!(status: "approved", approval_token: nil)
      redirect_to new_admin_session_path, notice: "Admin account has been approved."
    else
      redirect_to new_admin_session_path, alert: "Invalid approval token."
    end
  end
end