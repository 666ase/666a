require "uri"
require "net/http"

class NotificationJob < ApplicationJob
  queue_as :default

  rescue_from(StandardError) do |exception|
    puts exception.message
    puts exception.backtrace
    @document.notification_error! unless @document.nil?
  end

  def perform(document_code = nil, cascade = false)
    puts "NotificationJob: begin"

    if document_code.nil? then
      @document = Document.notification_pending.first
    else
      @document = Document.find_by(document_code:)
    end
    if @document.nil? then
      return
    end

    subscriptions = Subscription.where(company_code: @document.company_code)
    notifications = []
    subscriptions.each do |subscription|
      if !subscription.has_notification?(@document.id) then
        notifications << Notification.create(
          email_status: :email_pending, 
          subscription_id: subscription.id,
          document_id: @document.id,
        )
      end
    end

    @document.notification_success!

    puts "NotificationJob: end"

    if cascade then
      notifications.each_with_index do |notification, index|
        EmailJob.set(wait: index.seconds).perform_later(notification.id)
      end
    end
  end
end