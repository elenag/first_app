require 'test_helper'

class OrdersControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get review" do
    get :review
    assert_response :success
  end

  test "should get confirm" do
    get :confirm
    assert_response :success
  end

  test "should get list_all" do
    get :list_all
    assert_response :success
  end

  test "should get show_current" do
    get :show_current
    assert_response :success
  end

end
