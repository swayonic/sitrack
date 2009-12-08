ExceptionNotifier.exception_recipients = %w(justin.sabelko@uscm.org josh.starcher@gmail.com)
ExceptionNotifier.sender_address = %(sitrack@uscm.org)
ExceptionNotifier.email_prefix = "[SITRACK] "
FILTER_KEYS = %w(ssn)
ExceptionNotifier.filter_keys = FILTER_KEYS

# retrieve table_name_prefix from database.yml
# Had to move this here because USCM uses a shared database.yml file for all apps
TABLE_NAME_PREFIX = "si_"

ActionMailer::Base.smtp_settings = {
  :address => "smtp1.ccci.org",
  :domain => "ccci.org"
}

# Set the default place to find file_column files.
FILE_COLUMN_PREFIX = 'files'
module FileColumn
  module ClassMethods
    DEFAULT_OPTIONS[:root_path] = File.join(RAILS_ROOT, "public", FILE_COLUMN_PREFIX)
    DEFAULT_OPTIONS[:web_root] = "#{FILE_COLUMN_PREFIX}/"
  end
end
