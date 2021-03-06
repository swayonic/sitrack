require File.dirname(__FILE__) + '/../test_helper'
require 'directory_controller'

class DirectoryControllerTest < ActionController::TestCase
  fixtures :simplesecuritymanager_user, :ministry_person, :sitrack_users,
           :sitrack_views, :sitrack_columns, :sitrack_view_columns, :sitrack_queries,
           :sitrack_saved_criteria, :hr_si_applications
  def setup
    @controller = DirectoryController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
    # @request.sitrack_session = {:view_id => sitrack_views(:form).id}
  end

  # Basic action tests:
  def test_show_directory
    get :show_directory
    assert_response :success
  end
  
  def test_search
    post :search
    assert_response :success
  end
  
  def test_show_query_good_id
    get :show_query, :id => sitrack_queries(:yusef).id
    assert_response :success
  end
  
  def test_show_query_bad_id
    get :show_query, :id => 1
    assert_response :success
  end
  
  def test_show_query_no_id
    get :show_query
    assert_response :success
  end
  
  def test_show_criteria_good_id
    get :show_criteria, :id => sitrack_saved_criteria(:asdf).id
    assert_response :success
  end
  
  def test_show_criteria_bad_id
    get :show_criteria, :id => 1
    assert_response :success
  end
  
  def test_show_criteria_no_id
    get :show_criteria
    assert_response :success
  end
  
  def test_delete_query_no_id
    get :delete_query
    assert_response :success
  end
  
  def test_delete_query_good_id
    old_size = SitrackQuery.count
    get :delete_query, :id => sitrack_queries(:yusef).id
    assert_response :success
    assert SitrackQuery.count == old_size - 1
  end
  
  def test_delete_query_bad_id
    old_size = SitrackQuery.count
    get :delete_query, :id => 1
    assert_response :success
    assert SitrackQuery.count == old_size
  end
  
  def test_delete_criteria_no_id
    get :delete_criteria
    assert_response :success
  end
  
  def test_delete_criteria_good_id
    old_size = SitrackSavedCriteria.count
    get :delete_criteria, :id => sitrack_saved_criteria(:asdf).id
    assert_response :success
    assert SitrackSavedCriteria.count == old_size - 1
  end
  
  def test_delete_criteria_bad_id
    old_size = SitrackSavedCriteria.count
    get :delete_criteria, :id => 1
    assert_response :success
    assert SitrackSavedCriteria.count == old_size
  end
  
  def test_save_query
    post :save_query, :name => 'asdf', :id_list => '1,2,3'
    assert_response :success
    assert_not_nil SitrackQuery.find_by_name('asdf')
  end
  
  def test_save_query_bad
    post :save_query
    assert_response :success
  end
  
  def test_append_query
    old_id_list = sitrack_queries(:yusef).persons
    post :append_query, :id => sitrack_queries(:yusef).id, :id_list => '1,2,3'
    assert_response :success
    assert SitrackQuery.find(sitrack_queries(:yusef).id).persons != old_id_list
  end
  
  def test_append_query_bad_id
    post :append_query, :id => '1', :id_list => '1,2,3'
    assert_response :success
  end
  
  def test_save_criteria
    get :search
    post :save_criteria, :name => 'fdas'
    assert_response :success
    assert_not_nil SitrackSavedCriteria.find_by_name('fdas')
  end
  
  def test_save_criteria_no_id
    post :save_criteria, :name => 'fdas'
    assert_response :success
    assert_nil SitrackSavedCriteria.find_by_name('fdas')
  end
  
  def test_save_criteria_bad
    post :save_criteria
    assert_response :success
  end
  
  def test_change_region_without_param
    get :change_region
    assert_response :success
  end
  
  def test_change_region
    get :change_region, :region => 'SW'
    assert_response :success
    assert_equal assigns('sel_region_name'), 'SW'
  end
  
  def test_change_view_without_param
    get :change_view
    assert_response :success
  end
  
  def test_change_view_with_id
    get :change_view, :view_id => sitrack_views(:everything).id
    assert_response :success
    assert_equal assigns('view'), sitrack_views(:everything)
  end
  
  def test_no_access
    get :no_access
    assert_response :success
  end
  
  def test_calendar
    get :calendar, :SelectDate => "06/29/2005"
    assert_response :success
  end
  
  # excel tests
  def test_excel_download
    get :show_directory
    get :excel_download
    assert_response :success
  end
end
