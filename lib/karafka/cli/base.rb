# frozen_string_literal: true

module Karafka
  class Cli
    # Base class for all the command that we want to define
    # This base class provides an interface to easier separate single independent commands
    class Base
      # @return [Hash] given command cli options
      attr_reader :options

      # Creates new CLI command instance
      def initialize
        # Parses the given command CLI options
        @options = self.class.parse_options
      end

      # This method should implement proper cli action
      def call
        raise NotImplementedError, 'Implement this in a subclass'
      end

      class << self
        # Allows to set options for Thor cli
        # @see https://github.com/erikhuda/thor
        # @param option Single option details
        def option(*option)
          @options ||= []
          @options << option
        end

        # Allows to set description of a given cli command
        # @param desc [String] Description of a given cli command
        def desc(desc = nil)
          @desc ||= desc
        end

        # Allows to set aliases for a given cli command
        # @param args [Array] list of aliases that we can use to run given cli command
        def aliases(*args)
          @aliases ||= []
          @aliases << args.map(&:to_s)
        end

        # Parses the CLI options
        # @return [Hash] hash with parsed values
        def parse_options
          options = {}

          OptionParser.new do |opts|
            (@options || []).each do |option|
              # Creates aliases for backwards compatibility
              names = option[3].flat_map { |name| [name, name.tr('_', '-')] }
              names.map! { |name| "#{name} value1,value2,valueN" } if option[2] == Array
              names.uniq!

              opts.on(
                *[names, option[2], option[1]].flatten
              ) { |value| options[option[0]] = value }
            end
          end.parse!

          options
        end

        # @return [Array<Class>] available commands
        def commands
          ObjectSpace
            .each_object(Class)
            .select { |klass| klass.superclass == Karafka::Cli::Base }
            .reject { |klass| klass.to_s.end_with?('::Base') }
            .sort_by(&:name)
        end

        # @return [String] downcased current class name that we use to define name for
        #   given Cli command
        # @example for Karafka::Cli::Install
        #   name #=> 'install'
        def name
          to_s.split('::').last.downcase
        end

        # @return [Array<String>] names and aliases for command matching
        def names
          ((@aliases || []) << name).flatten.map(&:to_s)
        end
      end
    end
  end
end
