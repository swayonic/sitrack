require File.dirname(__FILE__) + '/../test_helper'
require 'salary_form_controller'

# Re-raise errors caught by the controller.
class SalaryFormController; def rescue_action(e) raise e end; end

class SalaryFormControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking
  
  def setup
    @controller = SalaryFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    @request.session[:cas_receipt] = {:user => 'josh.starcher@uscm.org',
                                      :ssoGuid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026'}
  end

  def test_fill_get
    get :fill, :id => hr_si_applications(:hero).id
    assert_response :success
  end
  
  def test_preview_stint
    post :fill, :id => hr_si_applications(:hero).id, :form => {:annual_salary => "600"}
    assert_response :success
    assert_template 'salary_form/preview'
  end
  
  def test_preview_intern
    post :fill, :id => hr_si_applications(:hero).id, :form => {:annual_salary => "600"}, :tracking => {:internType => 'Internship'}
    assert_response :success
    assert_template 'salary_form/preview'
  end
end
