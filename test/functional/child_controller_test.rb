require File.dirname(__FILE__) + '/../test_helper'
require 'child_controller'

# Re-raise errors caught by the controller.
class ChildController; def rescue_action(e) raise e end; end

class ChildControllerTest < Test::Unit::TestCase
  fixtures :sitrack_children, :ministry_person
  def setup
    @controller = ChildController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    @request.session[:cas_receipt] = {:user => 'josh.starcher@uscm.org',
                                      :ssoGuid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026'}
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