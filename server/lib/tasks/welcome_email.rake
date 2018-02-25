desc "Sends welcome emails to new tournaments"
task :send_welcome_emails => :environment do
  WelcomeEmailsJob.perform_later
end
