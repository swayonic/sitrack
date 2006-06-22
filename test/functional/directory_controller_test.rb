require File.dirname(__FILE__) + '/../test_helper'
require 'directory_controller'

# Re-raise errors caught by the controller.
class DirectoryController; def rescue_action(e) raise e end; end

class DirectoryControllerTest < Test::Unit::TestCase
  def setup
    @controller = DirectoryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Basic action tests:
  def test_show_directory
    get :show_directory
    assert_response :success
  end
end
