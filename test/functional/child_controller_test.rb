require File.dirname(__FILE__) + '/../test_helper'
require 'child_controller'

# Re-raise errors caught by the controller.
class ChildController; def rescue_action(e) raise e end; end

class ChildControllerTest < Test::Unit::TestCase
  def setup
    @controller = ChildController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
