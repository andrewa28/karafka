# frozen_string_literal: true

module Karafka
  class Cli < Thor
    # Base class for all the command that we want to define
    # This base class provides a nicer interface to Thor and allows to easier separate single
    # independent commands
    # In order to define a new command you need to:
    #   - specify its desc
    #   - implement call method
    #
    # @example Create a dummy command
    #   class Dummy < Base
    #     self.desc = 'Dummy command'
    #
    #     def call
    #       puts 'I'm doing nothing!
    #     end
    #   end
    class Base
      include Thor::Shell

      # We can use it to call other cli methods via this object
      attr_reader :cli

      # @param cli [Karafka::Cli] current Karafka Cli instance
      def initialize(cli)
        @cli = cli
      end

      # This method should implement proper cli action
      def call
        raise NotImplementedError, 'Implement this in a subclass'
      end

      class << self
        alias original_bind_to bind_to
        # Allows to set options for Thor cli
        # @see https://github.com/erikhuda/thor
        # @param option Single option details
        def option(*option)
          @options ||= []
          @options << option
        end

        # Allows to set description of a given cli command
        # @param args [Array] All the arguments that Thor desc method accepts
        def desc(*args)
          @desc ||= args
        end

        # Allows to set aliases for a given cli command
        # @param args [Array] list of aliases that we can use to run given cli command
        def aliases(*args)
          @aliases ||= []
          @aliases << args.map(&:to_s)
        end

        # This method will bind a given Cli command into Karafka Cli
        # This method is a wrapper to way Thor defines its commands
        # @param cli_class [Karafka::Cli] Karafka cli_class
        def bind_to(cli_class)
          @aliases ||= []
          @options ||= []

          # We're late to the party here, as the +karafka/cli/console+ and
          # +karafka/cli/server+ files were already required and therefore they
          # already wrote to the +@options+ array. So we will sanitize/split
          # the options here to allow correct usage of the original Karafka 1.4
          # +.bind_to+ method.
          @options.select! do |set|
            # We look for option sets without name (aliases),
            # a regular set looks like this: +[:daemon, {:default=>false, ..}]+
            next true unless set.first.is_a? Hash

            # An alias looks like this: +[{:aliases=>"s"}]+
            @aliases << set.first[:aliases].to_s

            # Strip this set from the options
            false
          end

          # Run the original Karafka 1.4 +.bind_to+ method
          original_bind_to(cli_class)

          # Configure the command aliases
          @aliases.each do |cmd_alias|
            cli_class.map cmd_alias => name.to_s
          end
        end

        private

        # @return [String] downcased current class name that we use to define name for
        #   given Cli command
        # @example for Karafka::Cli::Install
        #   name #=> 'install'
        def name
          to_s.split('::').last.downcase
        end
      end
    end
  end
end
