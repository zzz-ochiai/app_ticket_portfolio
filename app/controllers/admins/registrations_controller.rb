class Admins::RegistrationsController < Devise::RegistrationsController
  def create
    build_resource(sign_up_params)

    resource.status = "pending"
    resource.approval_token = SecureRandom.hex(16)

    resource.save

    yield resource if block_given?

    if resource.persisted?
      AdminMailer.approval_request(resource).deliver_now
      redirect_to new_admin_session_path, notice: "Admin approval request has been submitted."
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end