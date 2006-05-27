require File.dirname(__FILE__) + '/../test_helper'
require '/sitrack_savedcriteria_controller'

# Re-raise errors caught by the controller.
class SitrackSavedcriteriaController; def rescue_action(e) raise e end; end

class SitrackSavedcriteriaControllerTest < Test::Unit::TestCase
  fixtures :sitrack_savedcriteria

  def setup
    @controller = SitrackSavedcriteriaController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A better generator might actually keep updated tests in here, until then its probably better to have nothing than something broken

end
