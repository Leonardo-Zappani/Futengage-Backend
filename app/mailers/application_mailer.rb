# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: email_address_with_name('no-reply@FutEngage.io', 'FutEngage'),
          sender: email_address_with_name('no-reply@FutEngage.io', 'FutEngage'),
          reply_to: email_address_with_name('support@FutEngage.io', 'FutEngage')

  layout 'mailer'
end
