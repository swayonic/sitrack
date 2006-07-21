require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'

# Re-raise errors caught by the controller.
class ProfileController; def rescue_action(e) raise e end; end

class ProfileControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :hr_si_project, :sitrack_users,
           :simplesecuritymanager_user, :sitrack_columns
  def setup
    @controller = ProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    @request.session[:cas_receipt] = {:user => 'josh.starcher@uscm.org',
                                      :ssoGuid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026'}
  end

  def test_index_no_id
    get :index
    assert_response :redirect
  end
  
  def test_bad_id
    get :index, :id => 555 # smooth
    assert_response :redirect
  end
  
  def test_index
    get :index, :id => 1922
    assert_response :success
  end
  
  def test_edit_image
    get :edit_image, :id => 50069
    assert_response :success
  end
  
  def test_update_image
    post :update_image, :id => 50069
    assert_response :success
  end
  
  def test_create_second_year
    get :create_second_year, :id => hr_si_applications(:hero).id
    assert_response :redirect
  end
end
