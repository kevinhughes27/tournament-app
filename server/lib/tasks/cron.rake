namespace :cron do
  def cron_task(name, subtasks)
    task name => :environment do |task|
      run_subtasks(subtasks)
    end
  end

  def run_subtasks(subtasks)
    subtasks.each do |name|
      Rake::Task[name].invoke
    end
  end

  cron_task(:daily, [
    'send_welcome_emails',
  ])
end
