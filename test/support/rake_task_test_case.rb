class RakeTaskTestCase < ActiveSupport::TestCase
  setup do
    require 'rake'
    Rake::Task.define_task :environment
    load rake_task_load_path
  end

  teardown do
    Rake::Task.clear
  end

  private

  def subject
    Rake::Task[task_name]
  end

  def rake_task_load_path
    "#{_tasks_base_path}/#{_relative_task_file_path}"
  end

  def task_name
    _relative_task_file_path.sub('/', ':').sub(/\.rake$/, '')
  end

  def _relative_task_file_path
    "#{self.class.name.sub(/TaskTest$/, '').underscore}.rake"
  end

  def _tasks_base_path
    File.expand_path("#{Rails.root}/lib/tasks")
  end
end
