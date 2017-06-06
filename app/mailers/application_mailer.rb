# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  DEFAULT_FROM_EMAIL = ENV['FROM_DEFAULT_EMAIL'] || 'no-replay@taskboard.com'

  default from: DEFAULT_FROM_EMAIL
  layout 'mailer'
end
