def green(str)
  "\e[32m#{str}\e[0m"
end

def red(str)
  "\e[31m#{str}\e[0m"
end

namespace :ci do
  task :rails_tests do
    puts green("Running Rails tests")
    sh "bundle exec rails test"
  end

  task :bundle_audit do
    puts green("Running security audit on gems (bundle_audit)")
    sh "bundle exec bundle-audit update && bundle exec bundle-audit check"
  end

  task :nsp_check do
    puts green("Running security audit on packages (nsp)")
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
      puts green("PASSED")
      puts ""
    rescue Exception => e
      puts "#{e}"
      puts red("FAILED")
      puts ""
      raise(e)
    end
  end
end
