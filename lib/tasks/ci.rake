require 'rainbow'

namespace :ci do
  task :rails_tests do
    puts Rainbow("Running Rails tests").green
    sh "bundle exec rails test"
  end

  task :bundle_audit do
    puts Rainbow("Running security audit on gems (bundle_audit)").green
    sh "bundle exec bundle-audit update && bundle exec bundle-audit check"
  end

  task :nsp_check do
    puts Rainbow("Running security audit on packages (nsp)").green
    sh "./node_modules/nsp/bin/nsp check"
  end

  desc "Run all audits and tests"
  task all: [
    :environment,
    :bundle_audit,
    :rails_tests
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
