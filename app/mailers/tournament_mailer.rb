class TournamentMailer < ApplicationMailer
  default from: 'Kevin from Ultimate Tournament <kevin@ultimate-tournament.io>'

  def welcome_email(owner, tournament)
    mail(to: owner.email, subject: "Welcome to Ultimate Tournament")
  end

  def add_to_email(user, tournament)
    @tournament = tournament
    mail(to: user.email, subject: "You've been added to a tournament")
  end
end
