class ProfileController < ApplicationController
  caches_action :index
  
  def index
    # if we don't have an id in the request, go back to the directory
    unless params[:id]
      redirect_to(:controller => 'directory'); return;
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
    @person_obj = Person.find(@person['personID'])
    
    # get all the columns and create an hash of name=> column pairs
    @columns = Hash.new
    SitrackColumn.find_all.each {|c| @columns[c.name] = c}
    # set up options, first looking in the database
    @options = get_options
    
    @address_types = ['current','permanent','emergency1']
    @address_columns = %w{address1 address2 city state zip country homePhone cellPhone workPhone fax email contactName contactRelationship start_date end_date}
    
    # make sure we have all 3 types of addresses
    @address_types.each do |type|
      Address.create(:fk_PersonID => @person['personID'], :createdBy => 'SITRACK', :changedBy => 'SITRACK',
                   :dateCreated => Time.now, :dateChanged => Time.now, :addressType => type
                   ) unless Address.find(:first, :conditions => ["addressType = ? and fk_PersonID = ?", type, @person['personID']])
    end
    # create a hash of addresses
    @addresses = Hash.new
    @sql = "SELECT	addressType, address1, address2, city, state, zip, country, homePhone, cellPhone, "+
					 "workPhone, fax, email, contactName, contactRelationship, "+
					 "start_date, end_date, addressID "+
			     "FROM	#{Address.table_name} "+
			     "WHERE	fk_PersonID = #{@person['personID']}"
    Address.find_by_sql(@sql).each {|address| @addresses[address.addressType] = address}
    
    @children = SitrackChild.find(:all, :conditions => ['person_id = ?', @person['personID']])
    
    # get the enum options
    @option_hash = get_option_hash
    render(:action => :index)
  end

  def edit_image
    @person = Person.find(params[:id])
    render(:action => :edit_image, :layout => false)
  end
  
  def update_image
  	#make sure we have a person in the params
  	@person = Person.find(params[:id])
  	if params[:person] && @person
	    @person.image = params[:person][:image]
	    if @person.save
        # clear page caches
        @person.hr_si_applications do |app|
  	      expire_action(:action => :index, :id => app.id)
  	    end
        render(:template => '/shared/close_window', :layout => false)
      else 
    	  edit_image
	    end
	  else
	   edit_image
    end
  end  
  
  def create_second_year
    @first_year = HrSiApplication.find(params[:id])
    @second_year = @first_year.clone
    @tracking = @first_year.sitrack_tracking ? @first_year.sitrack_tracking.clone : SitrackTracking.new
    @tracking.asgYear = "#{Time.now.year}-#{Time.now.year+1}"
    @tracking.tenure = 'Second Year'
    @tracking.status = 'Re-Applied'
    @second_year.sitrack_tracking = @tracking
    @mpd = @first_year.sitrack_mpd ? @first_year.sitrack_mpd.clone : SitrackMpd.new
    @mpd.monthlyRaised = 0
    @mpd.oneTimeRaised = 0
    @mpd.totalRaised = 0
    @mpd.percentRaised = 0
    @second_year.sitrack_mpd = @mpd
    @second_year.save!
    # go to the new profile
    redirect_to(:action => :index, :id => @second_year.id)
  end
end
