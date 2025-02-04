# frozen_string_literal: true

module Karafka
  # Karafka framework Cli
  class Cli < Thor
    # Console Karafka Cli action
    class Console < Base
      desc 'Starts the Karafka console (short-cut alias: "c")'

      option :console, aliases: '-c'

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
        cli.info
        exec self.class.command
      end
    end
  end
end
