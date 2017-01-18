require 'rails/generators'
module FacebookMessengerBot
  module Generators
    class InstallGenerator < Rails::Generators::Base
      desc "Creates FacebookMessengerBot initializer for your application"

      def copy_initializer
        template "facebook_messenger_bot_initializer.rb", "config/initializers/messenger_bot.rb"

        puts "Install complete! Enjoy!"
      end


      def self.source_root
        @source_root ||= File.join(File.dirname(__FILE__), 'templates')
      end
    end
  end
end