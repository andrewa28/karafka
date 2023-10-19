# frozen_string_literal: true

module Karafka
  # Karafka framework Cli
  class Cli
    # Server Karafka Cli action
    class Server < Base
      # Server config settings contract
      CONTRACT = Contracts::ServerCliOptions.new.freeze

      private_constant :CONTRACT

      desc 'Start the Karafka server (short-cut alias: "s")'

      aliases :s

      option(
        :consumer_groups,
        'Runs server only with specified consumer groups',
        Array,
        %w[
          -g
          --consumer_groups
          --include_consumer_groups
        ]
      )

      option(
        :subscription_groups,
        'Runs server only with specified subscription groups',
        Array,
        %w[
          --subscription_groups
          --include_subscription_groups
        ]
      )

      option(
        :topics,
        'Runs server only with specified topics',
        Array,
        %w[
          --topics
          --include_topics
        ]
      )
      option(
        :exclude_subscription_groups,
        'Runs server without specified subscription groups',
        Array,
        %w[
          --exclude_subscription_groups
        ]
      )

      option(
        :exclude_topics,
        'Runs server without specified topics',
        Array,
        %w[
          --exclude_topics
        ]
      )

      # Start the Karafka server
      def call
        cli.info

        validate!

        if cli.options[:daemon]
          FileUtils.mkdir_p File.dirname(cli.options[:pid])
          daemonize
        end

        # We assign active topics on a server level, as only server is expected to listen on
        # part of the topics
        Karafka::Server.consumer_groups = cli.options[:consumer_groups]

        Karafka::Server.run
      end

      private

      # Checks the server cli configuration
      # options validations in terms of app setup (topics, pid existence, etc)
      def validate!
        result = CONTRACT.call(cli.options)
        return if result.success?

        SUPPORTED_TYPES.each do |type|
          names = options[type] || []

          names.each { |name| activities.include(type, name) }
        end
      end

      # Detaches current process into background and writes its pidfile
      def daemonize
        ::Process.daemon(true)
        File.open(
          cli.options[:pid],
          'w'
        ) { |file| file.write(::Process.pid) }

        activities.class::SUPPORTED_TYPES.each do |type|
          names = options[:"exclude_#{type}"] || []

          names.each { |name| activities.exclude(type, name) }
        end
      end

      # Removes a pidfile (if exist)
      def clean
        FileUtils.rm_f(cli.options[:pid]) if cli.options[:pid]
      end
    end
  end
end
