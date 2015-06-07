class Notifier < ApplicationMailer
  def remind_score_confirmation(recipient)
    mail(to: recipient, subject: "Blah ... yo confirm yo score man.")
  end
end