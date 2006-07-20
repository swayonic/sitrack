require File.dirname(__FILE__) + '/../test_helper'
require 'join_staff_form_controller'

# Re-raise errors caught by the controller.
class JoinStaffFormController; def rescue_action(e) raise e end; end

class JoinStaffFormControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :simplesecuritymanager_user
  
  def setup
    @controller = JoinStaffFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    @request.session[:cas_receipt] = {:user => 'josh.starcher@uscm.org',
                                      :ssoGuid => 'F167605D-94A4-7121-2A58-8D0F2CA6E026'}
  end

  def test_fill_get
    get :fill, :id => hr_si_applications(:hero).id
    assert_response :success
    assert_template 'join_staff_form/fill'
  end
  
  def test_preview
    post :fill, :id => hr_si_applications(:hero).id, :form => {:date_of_change => '2006-10-25', :hrd => 'me!'}, :mpd => {:coachName => 'you!'}
    assert_response :success
    assert_template 'join_staff_form/preview'
  end
end
