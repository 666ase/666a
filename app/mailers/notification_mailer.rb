class NotificationMailer < ApplicationMailer
  def notification_email()
    @notification = params[:notification]
    @result = @notification.result
    @user = @notification.refresh.subscription.user
    @url = "https://www.av.se/om-oss/sok-i-arbetsmiljoverkets-diarium/?id=" + @result.document_code
    mail(
      to: @user.email,
      subject: t("notification_email.title", document_code: @result.document_code),
    )
  end
end
