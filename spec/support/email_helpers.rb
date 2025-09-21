module EmailHelpers
  def clear_emails
    ActionMailer::Base.deliveries.clear
  end

  def last_email
    ActionMailer::Base.deliveries.last
  end

  def reset_password_link_from(email)
    body = email.body.encoded
    body[%r{https?://[^"\s]+/users/password/edit\?reset_password_token=[^"\s]+}]
  end
end

RSpec.configure do |config|
  config.include EmailHelpers, type: :system
end
