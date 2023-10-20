# frozen_string_literal: true

<<<<<<< HEAD
RSpec.describe Karafka::Cli::Console do
  subject(:console_cli) { described_class.new(cli) }

  let(:cli) { Karafka::Cli.new }
=======
RSpec.describe_current do
  subject(:console_cli) { described_class.new }
>>>>>>> 4cd72517 (Remove `thor` (#1680))

  specify { expect(described_class).to be < Karafka::Cli::Base }

  let(:info) { Karafka::Cli::Info.new }

  before { allow(info.class).to receive(:new).and_return(info) }

  describe '#call' do
<<<<<<< HEAD
    let(:cmd) do
      envs = [
        "IRBRC='#{Karafka.gem_root}/.console_irbrc'",
        'KARAFKA_CONSOLE=true'
      ]
      "#{envs.join(' ')} bundle exec irb -r #{Karafka.boot_file}"
=======
    context 'when running without rails' do
      let(:cmd) do
        envs = [
          'KARAFKA_CONSOLE=true',
          "IRBRC='#{Karafka.gem_root}/.console_irbrc'"
        ]
        "#{envs.join(' ')} bundle exec irb -r #{Karafka.boot_file}"
      end

      before do
        allow(info).to receive(:call)
        allow(console_cli).to receive(:exec)
      end

      it 'expect to execute irb with boot file required' do
        console_cli.call
        expect(info).to have_received(:call)
        expect(console_cli).to have_received(:exec).with(cmd)
      end
>>>>>>> 4cd72517 (Remove `thor` (#1680))
    end

    it 'expect to execute irb with boot file required' do
      expect(cli).to receive(:info)
      expect(console_cli).to receive(:exec).with(cmd)

<<<<<<< HEAD
      console_cli.call
=======
      before do
        allow(::Karafka).to receive(:rails?).and_return(true)
        allow(info).to receive(:call)
        allow(console_cli).to receive(:exec)
      end

      it 'expect to execute rails console' do
        console_cli.call
        expect(info).to have_received(:call)
        expect(console_cli).to have_received(:exec).with(cmd)
      end
>>>>>>> 4cd72517 (Remove `thor` (#1680))
    end
  end

  describe '#names' do
    it { expect(console_cli.class.names).to eq %w[c console] }
  end
end
