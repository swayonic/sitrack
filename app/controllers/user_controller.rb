class UserController < ApplicationController
  def search
    @people = ''
    @name = request.raw_post || request.query_string
    if @name and !@name.empty? 
    	names = @name.strip.split('%20')
    	if (names.size > 1)
	    	first = names[0].gsub("=", "")
    		last = names[1].empty? ? first : names[1].gsub("=", "")
	    	@conditions = [ "lastName LIKE ? AND firstName LIKE ? ", last + "%", first + "%" ]
	   	else 
	   	  name = names.join.gsub("=", "")
	   		@conditions = [ "(lastName LIKE ? OR firstName LIKE ?) ", name+'%',name+'%' ]
	   	end
	   	@conditions[0] += " AND fk_ssmUserId <> 0 AND fk_ssmUserId is NOT NULL "
	  	@people = Person.find(:all, :order => "lastName, firstName", :conditions => @conditions)
	  end
	  render(:layout => false)
  end
  
  def add
    unless (ssm_id = params[:ssm_id])
      raise "No user specified to add"
    end
    # see if the user already has access
    unless (@sitrack_user = SitrackUser.find_by_ssm_id(ssm_id))
      @sitrack_user = SitrackUser.create(:ssm_id => ssm_id, :created_by => current_user.id, :updated_by => current_user.id)
      # set the new user up with some default views
      UserController.create_views(@sitrack_user)
    end
    @person = Person.find(:first, :conditions => ['fk_ssmUserID  = ?', ssm_id])
	  render(:layout => false)
  end
  
  protected
    def self.create_views(si_user)
      SitrackView.find_all_by_sitrack_user_id(0).each do |view|
        new_view = view.clone
        view.sitrack_view_columns.each do |vc|
          new_view.sitrack_view_columns << vc.clone
        end
        si_user.sitrack_views << new_view
      end
    end
end
