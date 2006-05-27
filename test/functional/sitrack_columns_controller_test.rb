require File.dirname(__FILE__) + '/../test_helper'
require '/sitrack_columns_controller'

# Re-raise errors caught by the controller.
class SitrackColumnsController; def rescue_action(e) raise e end; end

class SitrackColumnsControllerTest < Test::Unit::TestCase
  fixtures :sitrack_columns

  def setup
    @controller = SitrackColumnsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  # A better generator might actually keep updated tests in here, until then its probably better to have nothing than something broken

end
