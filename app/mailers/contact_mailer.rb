class ContactMailer < ApplicationMailer
  default from: "from@example.com" # デフォルトの送信元アドレス

  def send_mail(contact)
    @contact = contact
    mail to: ENV['SMTP_USERNAME'], subject: 'お問い合わせ内容'
  end
end
