class Run
  def self.daily_tasks
    update_account_balances
  end
  
  def self.update_account_balances
    SitrackMpd.update_account_balances
  end
end
