class UserController < ApplicationController
  def index
  	@sitrack_users = SitrackUser.find(:all, :order => "ministry_person.lastName, ministry_person.firstName", :include => {:user => :person})
  end
  
  def search
    @people = []
    @name = params[:search][:name].squeeze(' ')
    if @name.present?
    	names = @name.split(' ')
    	if (names.size > 1)
	    	first = names[0].gsub("=", "")
    		last = names[1].empty? ? first : names[1].gsub("=", "")
	    	@conditions = [ "lastName LIKE ? AND (firstName LIKE ? OR preferredName LIKE ?) ", last + "%", first + "%", first + "%" ]
	   	else 
	   	  name = names.join.gsub("=", "")
	   		@conditions = [ "(lastName LIKE ? OR firstName LIKE ? OR preferredName LIKE ?) ", name+'%',name+'%',name+'%' ]
	   	end
	   	@conditions[0] += " AND fk_ssmUserId <> 0 AND fk_ssmUserId is NOT NULL "
	  	@total_people = Person.count(:all, :conditions => @conditions)
	  	@people = Person.find(:all, :order => "lastName, firstName", :conditions => @conditions, :limit => 15)
	  	if(@total_people > @people.count)
	  	  @message = "Showing #{@people.count} of #{@total_people} results<br/><span class='subtext'>Keep typing to filter the results</span>"
	  	else
	  	  @message = "Showing #{@total_people} result#{'s' if @total_people > 1}"
	  	end
	  end
    renderJS
  end
  
  def add
    ssm_id = params[:ssm_id]
    if ssm_id.present?
      # see if the user already has access
      if !SitrackUser.exists?(:ssm_id => ssm_id)
        @sitrack_user = SitrackUser.create(:ssm_id => ssm_id, :created_by => current_user.id, :updated_by => current_user.id)
      end
    end
    @sitrack_users = SitrackUser.find(:all, :order => "ministry_person.lastName, ministry_person.firstName", :include => {:user => :person})
    renderJS
  end
  
  def delete
    @id = params[:id]
    @sitrack_user = SitrackUser.find(@id)
    @sitrack_user.destroy
    @sitrack_users_count = SitrackUser.count(:all, :include => {:user => :person})
    renderJS
  end

end
