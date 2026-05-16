require "test_helper"

class AdminMailerTest < ActionMailer::TestCase
  test "approval_request" do
    mail = AdminMailer.approval_request
    assert_equal "Approval request", mail.subject
    assert_equal [ "to@example.org" ], mail.to
    assert_equal [ "from@example.com" ], mail.from
    assert_match "Hi", mail.body.encoded
  end
end
