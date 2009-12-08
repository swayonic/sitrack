require File.dirname(__FILE__) + '/../test_helper'
require 'profile_controller'

class ProfileControllerTest < ActionController::TestCase
  fixtures :hr_si_applications, :ministry_person, :hr_si_project, :sitrack_users,
           :simplesecuritymanager_user, :sitrack_columns
  def setup
    @controller = ProfileController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
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
