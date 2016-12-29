task :messenger_bot => :environment do
  require 'fileutils'

  if !File.exists?('config/initializers/messenger.rb')
      open('config/initializers/messenger.rb', "wb") { |file| file.write(
          "PAGE_ACCESS_TOKEN = 'page_access_token'
           VALIDATION_TOKEN = 'validation_token'"
      ) }
  end
end


