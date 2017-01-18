module FacebookMessengerBot
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("../../templates", __FILE__)
      desc "Creates FacebookMessengerBot initializer for your application"

      def copy_initializer
        template "facebook_messenger_bot_initializer.rb", "config/initializers/jem.rb"

        puts "Install complete! Enjoy!"
      end
    end
  end
end