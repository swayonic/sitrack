require File.dirname(__FILE__) + '/../test_helper'
require 'modify_controller'

class ModifyControllerTest < ActionController::TestCase
  fixtures :simplesecuritymanager_user, :ministry_person, :ministry_newaddress
  def setup
    @controller = ModifyController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
  end

   
  def test_modify_value_enum
    get :update, :value => 'D', :id => 1922, :type => 'enum', :fieldname => 'Marital Status', :colID => 42
    assert_response :success
  end
  
  def test_modify_value_address
    get :update, :value => 'somewhere', :id => 50069, :type => 'address', :fieldname => 'address1', :colID => 12229
    assert_response :success
  end
  
  def test_modify_value_date
    get :update, :value => "06/29/2005", :id => 4720, :type => 'date', :fieldname => 'Add Form', :colID => 115
    assert_response :success
  end
end
