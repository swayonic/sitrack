require File.dirname(__FILE__) + '/../test_helper'
require 'salary_form_controller'

class SalaryFormControllerTest < ActionController::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :simplesecuritymanager_user
  
  def setup
    @controller = SalaryFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
    #Intern preview options
    @preview_options = {:id => hr_si_applications(:hero).id, :form => {:annual_salary => "600", :tax_rate => 20}, :tracking => {:internType => 'Internship'}}
  end

  def test_fill_get
    get :fill, :id => hr_si_applications(:hero).id
    assert_response :success
  end
  
  def test_preview_stint
    @preview_options = {:id => hr_si_applications(:hero).id, :form => {:annual_salary => "600", :tax_rate => 20}}
    preview
  end
  
  def test_preview_intern
    preview
  end
  
  def test_submit
    submit
  end
end
