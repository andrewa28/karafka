# frozen_string_literal: true

RSpec.describe Karafka::Cli do
  subject(:cli) { described_class }

<<<<<<< HEAD
  describe '.prepare' do
    let(:command) { Karafka::Cli::Server }
    let(:commands) { [command] }

    it 'expect to use all Cli commands defined' do
      expect(command)
        .to receive(:bind_to)
        .with(cli)

      cli.prepare
    end
  end

  describe '.exit_on_failure?' do
    it { expect(cli.exit_on_failure?).to eq(true) }
  end

  describe '.cli_commands' do
=======
  describe '.commands' do
>>>>>>> 4cd72517 (Remove `thor` (#1680))
    let(:available_commands) do
      [
        Karafka::Cli::Console,
        Karafka::Cli::Flow,
        Karafka::Cli::Info,
        Karafka::Cli::Install,
<<<<<<< HEAD
        Karafka::Cli::Missingno,
        Karafka::Cli::Server
=======
        Karafka::Cli::Server,
        Karafka::Cli::Topics,
        Karafka::Cli::Help
>>>>>>> 4cd72517 (Remove `thor` (#1680))
      ].map(&:to_s).sort
    end

    it 'expect to return all cli commands classes' do
      expect(cli.send(:commands).map(&:to_s).sort).to eq available_commands
    end
  end
end
