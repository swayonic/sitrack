require File.dirname(__FILE__) + '/../test_helper'
require 'js_controller'

# Re-raise errors caught by the controller.
class JsController; def rescue_action(e) raise e end; end

class JsControllerTest < Test::Unit::TestCase
  def setup
    @controller = JsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
