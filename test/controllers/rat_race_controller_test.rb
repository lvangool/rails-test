require 'test_helper'

class RatRaceControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get rat_race_index_url
    assert_response :success
  end

end
