class ApplicationMailer < ActionMailer::Base
  default from: ENV['MAILJET_DEFAULT']
  layout "mailer"
end
