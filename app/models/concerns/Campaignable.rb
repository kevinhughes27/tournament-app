module Campiagnable
  extend ActiveSupport::Concern

  included do
    after_commit :subscribe_to_mailchimp, on: :create
  end

  private

  def subscribe_to_mailchimp
    return unless Rails.env.production?

    api_key = ENV['MAILCHIMP_API_KEY']
    list_uid = '5614c3cf70'

    gibbon = Gibbon::Request.new(api_key: api_key)
    gibbon.lists(list_uid).members.create(body: {
      email_address: email, status: "subscribed"
    })

  rescue Exception => e
    Rollbar.error(e)
  end
end
