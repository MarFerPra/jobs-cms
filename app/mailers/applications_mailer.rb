class ApplicationsMailer < ApplicationMailer

  def new_application(application)
    @application = application
    mailgun_client = Mailgun::Client.new Rails.application.secrets.mailgun_api_key
    message_params = {
      from: 'new-application@jobscms.com',
      to: 'mfernandezpranno@gmail.com',
      subject: 'New job application',
      text: application.to_json
    }

    mailgun_client.send_message Rails.application.secrets.mailgun_domain, message_params
  end

end
