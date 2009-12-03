require File.dirname(__FILE__) + '/../test_helper'
require 'user_controller'

class UserControllerTest < ActionController::TestCase
  def setup
    @controller = UserController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user] = User.find(:first)
  end

  # Replace this with your real tests.
  def test_truth
    assert true
  end
end
