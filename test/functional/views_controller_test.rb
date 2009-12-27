require File.dirname(__FILE__) + '/../test_helper'
require 'views_controller'

class ViewsControllerTest < ActionController::TestCase
  fixtures :simplesecuritymanager_user, :sitrack_users, :sitrack_views, 
           :sitrack_view_columns, :sitrack_columns
  def setup
    @controller = ViewsController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
  end

  def test_index
    get :index
    assert_response :success
    assert_template 'views/index'
  end
  
  def test_new_get
    get :new
    assert_response :success
    assert_template 'views/new'
  end
  
  def test_new_post
    post :new, :view => {:name => 'new_view'}
    assert_response :redirect
    
    assert_redirected_to edit_view_path(assigns(:view))
  end
end
