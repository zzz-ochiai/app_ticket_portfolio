class AdminMailer < ApplicationMailer
  def approval_request(admin)
    @admin = admin

    mail(
      to: "zzz.ochiai@gmail.com",
      subject: "Admin approval request"
    )
  end
end