# frozen_string_literal: true

<<<<<<< HEAD
RSpec.describe Karafka::Cli::Info do
  subject(:info_cli) { described_class.new(cli) }

  let(:cli) { Karafka::Cli.new }
=======
RSpec.describe_current do
  subject(:info_cli) { described_class.new }
>>>>>>> 4cd72517 (Remove `thor` (#1680))

  specify { expect(described_class).to be < Karafka::Cli::Base }

  describe '#call' do
    let(:info) do
      [
        "Karafka version: #{Karafka::VERSION}",
        "Ruby version: #{RUBY_VERSION}",
        "Ruby-kafka version: #{::Kafka::VERSION}",
        "Application client id: #{Karafka::App.config.client_id}",
        "Backend: #{Karafka::App.config.backend}",
        "Batch fetching: #{Karafka::App.config.batch_fetching}",
        "Batch consuming: #{Karafka::App.config.batch_consuming}",
        "Boot file: #{Karafka.boot_file}",
        "Environment: #{Karafka.env}",
        "Kafka seed brokers: #{Karafka::App.config.kafka.seed_brokers}"
      ].join("\n")
    end

    it 'expect to print details of this Karafka app instance' do
      expect(Karafka.logger).to receive(:info).with(info)
      info_cli.call
    end
  end

  describe '#names' do
    it { expect(info_cli.class.names).to eq %w[info] }
  end
end
