class WelcomeEmailsJob < ApplicationJob

  def perform
    tournaments.each do |tournament|
      tournament.update_column(:welcome_email_sent, true)

      owner = tournament.owner
      if owner.tournaments.where(welcome_email_sent: true).count > 1
        tournament.update_column(:welcome_email_sent, true)
        next
      end

      tournament.update_column(:welcome_email_sent, true)
      TournamentMailer.welcome_email(owner, tournament).deliver_later
    end
  end

  def tournaments
    Tournament.where(welcome_email_sent: false).where('created_at < ?', 2.days.ago)
  end
end
