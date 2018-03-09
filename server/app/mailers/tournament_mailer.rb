class TournamentMailer < ApplicationMailer
  default from: 'Kevin from Ultimate Tournament <kevin@ultimate-tournament.io>'

  def welcome_email(owner, tournament)
    mail(to: owner.email, subject: "Welcome to Ultimate Tournament")
  end
end
