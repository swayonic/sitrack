require File.dirname(__FILE__) + '/../test_helper'
require 'child_controller'

class ChildControllerTest < ActionController::TestCase
  fixtures :sitrack_children, :ministry_person, :simplesecuritymanager_user
  def setup
    @controller = ChildController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
  end

  # really basic bare minimum tests
  def test_add_child
    get :add_child, :id => 102546
    assert_response :success
  end
  
  def test_edit_child
    get :edit_child, :id => 1
    assert_response :success
  end
  
  def test_save_child
    post :save_child, :child => {:id => 1, :name => 'bob', :birthday => '5/5/2000', :person_id => 102546}
    assert_response :success
  end
  
  def test_delete_child
    xhr :post, :delete_child, :id => 1
    assert_response :success
  end
end
