# frozen_string_literal: true

module Karafka
  # Karafka framework Cli
  class Cli
    # Server Karafka Cli action
    class Server < Base
      # Server config settings contract
      CONTRACT = Contracts::ServerCliOptions.new.freeze

      private_constant :CONTRACT

      desc 'Starts the Karafka server (short-cut alias: "s")'

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
        :exclude_consumer_groups,
        'Runs server without specified consumer groups',
        Array,
        %w[
          --exclude_consumer_groups
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

        register_inclusions
        register_exclusions

        Karafka::Server.run
      end

      private

      # Registers things we want to include (if defined)
      def register_inclusions
        activities = ::Karafka::App.config.internal.routing.activity_manager

        SUPPORTED_TYPES.each do |type|
          names = options[type] || []

          names.each { |name| activities.include(type, name) }
        end
      end

      # Registers things we want to exclude (if defined)
      def register_exclusions
        activities = ::Karafka::App.config.internal.routing.activity_manager

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
