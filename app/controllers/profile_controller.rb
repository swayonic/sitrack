class ProfileController < ApplicationController
#  caches_action :index
  def index
    # if we don't have an id in the request, go back to the directory
    if params[:form_id]
      form = SitrackForm.find(params[:form_id])
      params[:id] ||= form.hr_si_application_id.to_s
    end
    unless params[:id]
      redirect_to(:controller => 'directory'); return;
    end
    
    # if they don't have a tracking record, now would be a good time to create one.
    @tracking = SitrackTracking.find_by_application_id(params[:id])
    unless @tracking  # if they don't have a tracking record, now would be a good time to create one.
      hr_app = HrSiApplication.find(params[:id])
      intern_type = nil
      intern_type = hr_app.app_type if hr_app
      intern_type = "Internship" if intern_type == "US Internship"
      SitrackTracking.create(:application_id => params[:id], :internType => intern_type)
    end
    # build query
    @sql =  "SELECT personID, applicationID, "+SitrackColumn.all_select_clauses
    @sql += " FROM "+SitrackView.join_tables
    @sql += " WHERE applicationID = "+escape_string(params[:id])
    
    # if we don't have a person, go back to the directory
    @person = ActiveRecord::Base.connection.select_one(@sql)
    if !@person
      redirect_to(:controller => 'directory'); return; 
    end
    
    # sometimes it's useful to have the person as an object instead of a hash
    Rails.logger.info ">>>>>>>>> #{@person['personID']}"
    @person_obj = Person.find(@person['personID'])
    
    # determine whether to give option to create second year record
    @num_valid_apps = 0
    @person_obj.hr_si_applications.each do |app|
      if (!app.apply.nil?)
        @num_valid_apps += 1 if ["on_assignment", "placed", "alumni"].include?(app.apply.status)
      else # no apply record so assume it's valid
        @num_valid_apps += 1
      end
    end
    
    # get all the columns and create an hash of name=> column pairs
    @columns = Hash.new
    SitrackColumn.all.each {|c| @columns[c.name] = c}
    # set up options, first looking in the database
    @options = get_options
    @teams = get_teams
    @teams_ordered = get_teams_ordered
    @address_types = ['current','permanent','emergency1']
    @address_columns = %w{address1 address2 city state zip country homePhone cellPhone workPhone fax email email2 contactName contactRelationship start_date end_date}
    
    # make sure we have all 3 types of addresses
    @address_types.each do |type|
      Address.create(:fk_PersonID => @person['personID'], :createdBy => 'SITRACK', :changedBy => 'SITRACK',
                   :dateCreated => Time.now, :dateChanged => Time.now, :addressType => type
                   ) unless Address.find(:first, :conditions => ["addressType = ? and fk_PersonID = ?", type, @person['personID']])
    end
    # create a hash of addresses
    @addresses = Hash.new
    @sql = "SELECT	addressType, address1, address2, city, state, zip, country, homePhone, cellPhone, "+
					 "workPhone, fax, email, email2, contactName, contactRelationship, "+
					 "start_date, end_date, addressID "+
			     "FROM	#{Address.table_name} "+
			     "WHERE	fk_PersonID = #{@person['personID']}"
    Address.find_by_sql(@sql).each {|address| @addresses[address.addressType] = address}
    
    @children = SitrackChild.find(:all, :conditions => ['person_id = ?', @person['personID']])
    
    # get the enum options
    @options_hash = get_option_hash
    render(:action => :index)
  end

  def edit_image
    success = false
    @person = Person.find(params[:id])
    # Check if there is an input
    if params[:person].present? && params[:person][:url].present?
      url = params[:person][:url]
      
      # Get UID from URL
      fb_uid = get_uid(url)
      if fb_uid.present?
        # Get ID from UID
        fb_id = get_id(fb_uid)
        if fb_id.present?
          @person.fb_uid = fb_id
          if @person.save!
            # clear page caches
            @person.hr_si_applications do |app|
              expire_action(:controller => 'profile', :action => 'index', :id => app.id)
            end
            success = true
          else
            flash[:notice] = "Please try again"
          end
        else
          flash[:notice] = "Facebook user not found"
        end
      else
        flash[:notice] = "Please enter a valid URL"
      end
    end
    if success
      close_window
    else
      @fb_url = @person.fb_uid.present? ? "https://www.facebook.com/#{@person.fb_uid}" : ""
      render :layout => false
    end
  end
  
  def create_second_year
    @first_year = HrSiApplication.find(params[:id])
    @second_year = HrSiApplication.new(
                    @first_year.attributes.except('id', 'applicationID', 'updated_at', 'created_at'), 
                    without_protection: true)
                    
    if @first_year.apply.present?
      @apply = Apply.new(
                @first_year.apply.attributes.except('id', 'updated_at', 'created_at'),
                without_protection: true)
    else 
      @apply = Apply.new
    end
    @second_year.apply = @apply
    
    if @first_year.sitrack_tracking.present?
      @tracking = SitrackTracking.new(
                    @first_year.sitrack_tracking.attributes.except('id', 'updated_at', 'created_at'),
                    without_protection: true)
    else
      @tracking = SitrackTracking.new
    end
    @tracking.asgYear = "#{Time.now.year}-#{Time.now.year+1}"
    @tracking.tenure = 'Second Year'
    @tracking.status = 'Re-Applied'
    @second_year.sitrack_tracking = @tracking
    
    if @first_year.sitrack_mpd.present?
      @mpd = SitrackMpd.new(
              @first_year.sitrack_mpd.attributes.except('id', 'updated_at', 'created_at'),
              without_protection: true)
    else
      @mpd = SitrackMpd.new
    end
    @mpd.monthlyRaised = 0
    @mpd.oneTimeRaised = 0
    @mpd.totalRaised = 0
    @mpd.percentRaised = 0
    @second_year.sitrack_mpd = @mpd
    
    @second_year.save!
    # go to the new profile
    redirect_to(:action => :index, :id => @second_year.id)
  end
  
  private
  
  def get_uid(url)
    if url.include?("facebook.com") || url.include?("fb.com")
      if url.include?("id=")
        uid = url.split('id=').last
      elsif url.include?("/")
        uid = url.split('/').last
      end
    end
    uid
  end
  
  def get_id(uid)
    begin
      response = RestClient.get("https://graph.facebook.com/#{uid}")
      response = JSON.parse(response)
      response['id']
    rescue
      nil
    end
  end
  
  def close_window
      render(:template => '/shared/close_window', :layout => false)
  end
  
end
