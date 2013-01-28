require 'test_helper'

class ContentGroupControllerTest < ActionController::TestCase
  test "should get list_all" do
    get :list_all
    assert_response :success
  end

end
