require File.dirname(__FILE__) + '/../test_helper'
require 'add_form_controller'

# Re-raise errors caught by the controller.
class AddFormController; def rescue_action(e) raise e end; end

class AddFormControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :ministry_newaddress
  
  def setup
    @controller = AddFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    @request.session[:cas_receipt] = {:user => 'josh.starcher@uscm.org',
                                      :ssoGuid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026'}
  end

  def test_preview
    get :fill, :id => hr_si_applications(:hero).id
    assert_response :success
    assert_template 'add_form/preview'
  end
end
