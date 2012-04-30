Airbrake.configure do |config|
  config.api_key		= 'db4bcd62d3dc32652a882e53ec2d8eb5'
  config.host				= 'errors.uscm.org'
  config.port				= 80
  config.secure			= config.port == 443
end