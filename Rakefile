# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Rails.application.load_tasks

Rake::Task['test:run'].clear

namespace :test do
  task :js => ['spec:javascript']

  Rake::TestTask.new(:_all) do |t|
    t.libs << "test"
    t.test_files = FileList['test/**/*_test.rb']
  end

  Rake::TestTask.new(:_run) do |t|
    t.libs << "test"
    t.test_files = FileList['test/**/*_test.rb'].exclude(
      'test/browser/**/*_test.rb'
    )
  end

  Rake::TestTask.new('browser' => 'test:prepare') do |t|
    t.libs << 'test'
    t.pattern = 'test/browser/**/*_test.rb'
  end

  task :run => ['test:_run', 'test:js', 'test:browser']
  task :run_ci => ['test:_all', 'test:js']
end
