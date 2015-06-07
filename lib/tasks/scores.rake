# this task will be scheduled by heroku
# can run with `bundle exec rake scores:nag`
namespace :scores do
  task :nag => :environment do
    time = Time.now.strftime("%d/%m/%Y %H:%M")
    games = Record.find(:all, :conditions => ["score_confirmed = ?", false]
    games.each do |game|
     	Notifier.email_team_captain(game).deliver_now
  end
end