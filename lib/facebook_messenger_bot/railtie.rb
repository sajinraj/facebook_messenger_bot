require 'facebook_messenger_bot'
require 'rails'
module FacebookMessengerBot
  class Railtie < Rails::Railtie
    rake_tasks do
      require 'tasks/messenger_bot.rake'
    end
  end
end