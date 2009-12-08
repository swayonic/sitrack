require File.dirname(__FILE__) + '/../test_helper'
require 'add_form_controller'

class AddFormControllerTest < ActionController::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, :ministry_newaddress, :simplesecuritymanager_user
  
  def setup
    @controller = AddFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user_id] = User.find(:first).id
    @preview_options = {"person"=>{"birth_date(2i)"=>"11", "birth_date(3i)"=>"11", "lastName"=>"Allen", "isSecure"=>"T", "firstName"=>"Eben", "birth_date(1i)"=>"1984"}, "tracking"=>{"asgTeam"=>"588", "sendLane"=>"Epic", "caringRegion"=>"GL", "send_dept"=>"979", "regionOfOrigin"=>"NW"}, "action"=>"fill", :id => hr_si_applications(:hero).id, "application"=>{"ssn"=>"[FILTERED]"}, "controller"=>"add_form"}

  end

  def test_preview
    preview
  end
  
  def test_submit
    submit
  end
end
