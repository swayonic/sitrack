require File.dirname(__FILE__) + '/../test_helper'
require 'add_form_controller'

# Re-raise errors caught by the controller.
class AddFormController; def rescue_action(e) raise e end; end

class AddFormControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :ministry_newaddress, :simplesecuritymanager_user
  
  def setup
    @controller = AddFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user] = User.find(:first)
    @preview_options = {:id => hr_si_applications(:hero).id}
  end

  def test_preview
    preview
  end
  
  def test_submit
    submit
  end
end
