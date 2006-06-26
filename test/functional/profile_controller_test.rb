require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'

# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < Test::Unit::TestCase
  fixtures :hr_si_application, :ministry_person, :hr_si_project
  def setup
    @controller = ProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
  end

  def test_index_no_id
    get :index
    assert_response :redirect
  end
  
  def test_index
    get :index, :id => 1922
    assert_response :success
  end
end
