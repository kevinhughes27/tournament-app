require 'test_helper'
require_relative 'rake_task_test_case'

class MaintenanceTaskTextCase < RakeTaskTestCase
  private
  def task_name
    'm:' + _relative_task_file_path.sub('/', ':').sub(/\.rake$/, '')
  end

  def _tasks_base_path
    File.expand_path("#{Rails.root}/lib/tasks/maintenance")
  end
end
