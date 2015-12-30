require 'test_helper'

class BrochureTest < ActionDispatch::IntegrationTest

  test "index" do
    get '/'
    assert_equal 200, status
  end

end
