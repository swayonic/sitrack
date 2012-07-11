class Run
  def self.fix_applies
    result = Apply.connection.execute("select applicationID from hr_si_applications group by apply_id having count(apply_id) > 1 order by fk_personID")
    result.each do |r|
      app = HrSiApplication.find(r).first
      apply = app.apply
      apps = HrSiApplication.find_all_by_apply_id(apply.id, :order => :applicationid)
      last_app = apps.last
      new_apply = apply.clone
      last_app.apply = new_apply
      last_app.save!
      new_apply.update_attribute(:status, apply.status)
    end
  end
end
