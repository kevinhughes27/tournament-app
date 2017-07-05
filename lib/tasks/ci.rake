require 'rainbow'

namespace :ci do
  task :rails_tests do
    puts Rainbow("Running Rails tests").green
    sh "bundle exec rails test"
  end

  task :bracket_db_tests do
    puts Rainbow("Running BracketDb tests").green
    sh "cd lib/bracket_db && bundle exec rake test"
  end

  task :js_tests do
    puts Rainbow("Running JavaScript tests").green
    sh "bundle exec teaspoon"
  end

  task :bundle_audit do
    puts Rainbow("Running security audit on gems (bundle_audit)").green
    sh "bundle exec bundle-audit update && bundle exec bundle-audit check"
  end

  task :nsp_check do
    puts Rainbow("Running security audit on packages (nsp)").green
    sh "nsp check"
  end

  desc "Run all audits and tests"
  task all: [
    :environment,
    :rails_tests,
    :bracket_db_tests,
    :js_tests,
    :bundle_audit,
    :nsp_check
  ] do
    begin
      puts "All CI tasks"
      puts Rainbow("PASSED").green
      puts ""
    rescue Exception => e
      puts "#{e}"
      puts Rainbow("FAILED").red
      puts ""
      raise(e)
    end
  end
end
