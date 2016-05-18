class TournamentMailer < ApplicationMailer
  default from: 'kevin@ultimate-tournament.io'

  def welcome_email(owner, tournament)
    mail(to: owner.email, subject: "Kevin from Ultimate Tournament")
  end
end
