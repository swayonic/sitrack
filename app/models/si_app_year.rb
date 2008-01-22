class SiAppYear
  def self.all
    years = []
    (2003..HrSiApplication::YEAR).sort{|a,b| b<=>a}.each do |year|
      years << ['y'+year.to_s,year]
  	end
  	return years
  end
end