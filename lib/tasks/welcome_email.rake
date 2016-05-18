desc "Sends welcome emails to new tournaments"
task :send_welcome_emails => :environment do
  SendWelcomeEmailsJob.perform_later
end
