require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get success" do
    get pages_success_url
    assert_response :success
  end

  test "should get failure" do
    get pages_failure_url
    assert_response :success
  end
end
