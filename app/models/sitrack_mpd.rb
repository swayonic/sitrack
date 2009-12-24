class SitrackMpd < ActiveRecord::Base
  belongs_to :hr_si_application, :foreign_key => 'application_id'
  
  def self.update_account_balances
    balances = PsEmployee.get_balances
    mpd_records = find(:all)
    mpd_records.each do |mpd|
      app = mpd.hr_si_application
      person = app.person if app
      accNo = person.accountNo if person
      mpd.account_balance = balances[accNo] if accNo
    end
    puts Time.now
    puts "Finished"
    0
  end
  
  def account_balance=(balance)
    class << self
      def record_timestamps; false; end
    end
    self[:account_balance] = balance
    save!
    class << self
      remove_method :record_timestamps
    end
  end

end
