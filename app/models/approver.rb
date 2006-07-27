# == Schema Information
# Schema version: 17
#
# Table name: ministry_Person
#
#  personID                       :integer(10)   not null, primary key
#  accountNo                      :string(11)    
#  lastName                       :string(50)    
#  firstName                      :string(50)    
#  middleName                     :string(50)    
#  preferredName                  :string(50)    
#  gender                         :string(1)     
#  deprecated_birthDate           :string(25)    
#  deprecated_dateBecameChristian :string(35)    
#  region                         :string(5)     
#  workInUS                       :boolean(1)    default(true), not null
#  usCitizen                      :boolean(1)    default(true), not null
#  citizenship                    :string(50)    
#  isStaff                        :boolean(1)    not null
#  title                          :string(5)     
#  campus                         :string(128)   
#  universityState                :string(5)     
#  yearInSchool                   :string(20)    
#  deprecated_graduationDate      :string(25)    
#  major                          :string(70)    
#  minor                          :string(70)    
#  greekAffiliation               :string(50)    
#  maritalStatus                  :string(20)    
#  numberChildren                 :string(2)     
#  isChild                        :boolean(1)    not null
#  bio                            :text          
#  image                          :string(100)   
#  occupation                     :string(50)    
#  blogfeed                       :string(200)   
#  cruCommonsInvite               :datetime      
#  cruCommonsLastLogin            :datetime      
#  dateCreated                    :datetime      
#  dateChanged                    :datetime      
#  createdBy                      :string(50)    
#  changedBy                      :string(50)    
#  fk_ssmUserId                   :integer(10)   
#  fk_StaffSiteProfileID          :integer(10)   
#  fk_spouseID                    :integer(10)   
#  fk_childOf                     :integer(10)   
#  birth_date                     :datetime      
#  date_became_christian          :datetime      
#  graduation_date                :datetime      
#

class Approver < Person
end
