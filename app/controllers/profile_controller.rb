class ProfileController < ApplicationController
  def index
    # build query
    @sql =  "SELECT personID, applicationID, "+SitrackColumn.all_select_clauses
    @sql += " FROM "+SitrackView.join_tables
    @sql += " WHERE applicationID = "+escape_string(params[:id])
    
    # if we don't have a person, go back to the directory
    @person = ActiveRecord::Base.connection.select_one(@sql)
    redirect_to(:controller => 'directory') if !@person
    
    # get all the columns and create an hash of name=> column pairs
    @columns = Hash.new
    SitrackColumn.find_all.each {|c| @columns[c.name] = c}
    # set up options, first looking in the database
    @options = get_options
    
    @address_types = ['current','permanent','emergency1']
    @address_columns = %w{address1 address2 city state zip country homePhone cellPhone workPhone fax email contactName contactRelationship startdate enddate}
    # create a hash of addresses
    @addresses = Hash.new
    @sql = "SELECT	addressType, address1, address2, city, state, zip, country, homePhone, cellPhone, "+
					 "workPhone, fax, email, contactName, contactRelationship, "+
					 "startdate, enddate, addressID "+
			     "FROM	#{Address.table_name} "+
			     "WHERE	fk_PersonID = #{@person['personID']}"
    Address.find_by_sql(@sql).each {|address| @addresses[address.addressType] = address}
    @children = SitrackChild.find(:all, :conditions => ['person_id = ?', @person['personID']])
    
    # get the enum options
    @option_hash = get_option_hash
  end
end
