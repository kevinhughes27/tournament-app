# this task will be scheduled by heroku
# can run with `bundle exec rake scores:nag`
namespace :scores do
  task :nag => :environment do
    puts 'hello!'
  end
end