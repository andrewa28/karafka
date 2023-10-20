# frozen_string_literal: true

module Karafka
  # Karafka framework Cli
  class Cli
    # Console Karafka Cli action
    class Console < Base
      desc 'Starts the Karafka console (short-cut alias: "c")'

      aliases :c

      class << self
        # @return [String] Console executing command
        # @example
        #   Karafka::Cli::Console.command #=> 'KARAFKA_CONSOLE=true bundle exec irb...'
        def command
          envs = [
            "IRBRC='#{Karafka.gem_root}/.console_irbrc'",
            'KARAFKA_CONSOLE=true'
          ]
          "#{envs.join(' ')} bundle exec irb -r #{Karafka.boot_file}"
        end
      end

      # Start the Karafka console
      def call
        Info.new.call

        command = ::Karafka.rails? ? self.class.rails_console : self.class.console

        exec "KARAFKA_CONSOLE=true #{command}"
      end
    end
  end
end
