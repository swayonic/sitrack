require File.dirname(__FILE__) + '/../test_helper'
require 'acos_form_controller'

# Re-raise errors caught by the controller.
class AcosFormController; def rescue_action(e) raise e end; end

class AcosFormControllerTest < Test::Unit::TestCase
  fixtures :hr_si_applications, :ministry_person, :sitrack_tracking, 
           :simplesecuritymanager_user, :sitrack_users, :sitrack_enum_values,
           :sitrack_columns
  
  def setup
    @controller = AcosFormController.new
    @request    = ActionController::TestRequest.new
    @response   = ActionController::TestResponse.new
    # fake cas
    CAS::Filter.fake = true
    @request.session[:user] = User.find(:first)
    @preview_options = {:id => hr_si_applications(:hero).id, :form => {:action => 'termination', :date_of_change => '2006-10-25'}}
  end

  def test_fill_get
    get :fill, :id => hr_si_applications(:hero).id
    assert_response :success
    assert_template 'acos_form/fill'
  end
  
  def test_preview
    preview
  end
  
  def test_change_region
    @preview_options = {"id" => hr_si_applications(:travis).id, "tracking"=>{"departureDate(1i)"=>"2006", "departureDate(2i)"=>"9", "departureDate(3i)"=>"19", "caringRegion"=>"SW"}, "form"=>{"change_assignment_to_location"=>"", "freeze_end(2i)"=>"7", "date_of_change(3i)"=>"26", "freeze_end(3i)"=>"26", "other_explanation"=>"", "restint_location"=>"DES, BZH1, BZH", "action"=>"toStint", "freeze_start(1i)"=>"2006", "change_assignment_from_location"=>"DES, BZH1, BZH", "freeze_start(2i)"=>"7", "date_of_change(1i)"=>"2006", "freeze_start(3i)"=>"26", "freeze_end(1i)"=>"2006", "date_of_change(2i)"=>"7", "hours_per_week"=>""}, "person"=>{"region"=>"MS"}}
    preview
  end
  
  def test_submit
    submit
  end
end
