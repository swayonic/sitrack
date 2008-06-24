class PeopleController < ApplicationController
  def new
    @person = Person.new
    @current_address = CurrentAddress.new
    respond_to do |format|
      format.html
      # format.js
    end
  end
  
  def create
    if request.post?
      @person = Person.new(params[:person])
      params[:current_address][:addressType] = "current"
      @current_address = CurrentAddress.new(params[:current_address])
      respond_to do |format|
        if @person.valid? && @current_address.valid?
          # ===============================================
          # = Check for duplicate person. VERY IMPORTANT! =
          # ===============================================
          exact = Person.find_exact(@person, @current_address)
          # similar = Person.find_similar(@person, @current_address)
          if exact
            # Get rid of empty values
            params[:person].delete_if {|key, value| value.strip == "" } 
            params[:current_address].delete_if {|key, value| value.strip == "" } 
            exact.update_attributes(params[:person])
            @person = exact
            @person.current_address ||= @current_address
            @person.current_address.update_attributes(params[:current_address])
            @current_address = @person.current_address
          else
            @person.save
            # add address
            @person.current_address = @current_address
          end
          
          # if this person doesn't have a region, default to the current user's region
          @person.region ||= session[:sitrack_user].user.person.region
          @person.save
          
          # try to create a user row for the person.
          username_conflict = User.find_by_username(@current_address.email)
          @person.user = User.new(:username => @current_address.email, :createdOn => Time.now()) unless username_conflict
          @application = HrSiApplication.new(:fk_personID => @person.id)
          @application.sitrack_tracking = SitrackTracking.new()
          @person.hr_si_applications << @application
          
          flash[:notice] = 'Person was successfully created.'
          format.html { redirect_to :controller => 'profile', :action => 'index', :id => @application.id }
        else
          format.html { render :action => "new" }
        end
      end
    else
      redirect_to :action => :new
    end
  end
      
  def delete_prompt
    @applications = HrSiApplication.find(:all, :conditions => ["ApplicationID IN (?)", params[:id_list].split(',')], :include => :person)
  end
  
  def delete
    ids = params[:id_list].split(',').collect(&:to_i).join(',')
    @applications = HrSiApplication.find(:all, :conditions => ["ApplicationID IN (?)", params[:id_list].split(',')], :include => :sitrack_tracking)
    @applications.each do |app|
      app.sitrack_tracking.destroy
      app.destroy
    end
    redirect_to '/directory'
  end
end