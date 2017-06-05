# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'np-reply@taskboard.com'
  layout 'mailer'
end
