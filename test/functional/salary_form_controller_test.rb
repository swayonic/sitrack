require File.dirname(__FILE__) + '/../test_helper'
require 'salary_form_controller'

# Re-raise errors caught by the controller.
class SalaryFormController; def rescue_action(e) raise e end; end

class SalaryFormControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :simplesecuritymanager_user
  
  def setup
    @controller = SalaryFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user] = User.find(:first)
    #Intern preview options
    @preview_options = {:id => hr_si_applications(:hero).id, :form => {:annual_salary => "600"}, :tracking => {:internType => 'Internship'}}
  end

  def test_fill_get
    get :fill, :id => hr_si_applications(:hero).id
    assert_response :success
  end
  
  def test_preview_stint
    @preview_options = {:id => hr_si_applications(:hero).id, :form => {:annual_salary => "600"}}
    preview
  end
  
  def test_preview_intern
    preview
  end
  
  def test_submit
    submit
  end
end
