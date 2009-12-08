require File.dirname(__FILE__) + '/../test_helper'
require 'additional_salary_form_controller'

class AdditionalSalaryFormControllerTest < ActionController::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :simplesecuritymanager_user
  
  def setup
    @controller = AdditionalSalaryFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
    @preview_options = {:id => hr_si_applications(:hero).id}
  end

  def test_fill_get
    get :fill, :id => hr_si_applications(:hero).id
    assert_response :success
    assert_template 'additional_salary_form/fill'
  end
  
  def test_preview
    preview
  end
  
  def test_submit
    submit
  end
end
