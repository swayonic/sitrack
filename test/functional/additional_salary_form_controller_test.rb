require File.dirname(__FILE__) + '/../test_helper'
require 'additional_salary_form_controller'

# Re-raise errors caught by the controller.
class AdditionalSalaryFormController; def rescue_action(e) raise e end; end

class AdditionalSalaryFormControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :simplesecuritymanager_user
  
  def setup
    @controller = AdditionalSalaryFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    @request.session[:cas_receipt] = {:user => 'josh.starcher@uscm.org',
                                      :ssoGuid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026'}
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
