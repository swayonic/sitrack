require File.dirname(__FILE__) + '/../test_helper'
require '/sitrack_children_controller'

# Re-raise errors caught by the controller.
class SitrackChildrenController; def rescue_action(e) raise e end; end

class SitrackChildrenControllerTest < Test::Unit::TestCase
  fixtures :sitrack_children

  def setup
    @controller = SitrackChildrenController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A better generator might actually keep updated tests in here, until then its probably better to have nothing than something broken

end
