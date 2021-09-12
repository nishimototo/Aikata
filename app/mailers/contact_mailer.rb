class ContactMailer < ApplicationMailer
  default from: "from@example.com" #デフォルトの送信元アドレス

  def send_mail(contact)
    @contact = contact
    mail to: @contact.email, subject: 'お問い合わせ内容'
  end
end
