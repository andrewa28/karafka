# frozen_string_literal: true

<<<<<<< HEAD
RSpec.describe Karafka::Cli::Base do
  describe 'instance methods' do
    subject(:base_cli) { described_class.new(cli) }

    let(:cli) { Karafka::Cli.new }

    describe '#cli' do
      it { expect(base_cli.cli).to eq cli }
    end
  end

=======
RSpec.describe_current do
>>>>>>> 4cd72517 (Remove `thor` (#1680))
  describe 'class methods' do
    subject(:base_cli_class) { described_class }

    describe '#name' do
      it { expect(base_cli_class.name).to eq 'base' }
    end

    describe '#names' do
      it { expect(base_cli_class.names).to eq %w[base] }
    end

    describe '#load' do
      it { expect { base_cli_class.load }.to raise_error(::Karafka::Errors::MissingBootFileError) }
    end
  end

  describe '#call' do
    subject(:base_cli) { described_class.new }

    it { expect { base_cli.call }.to raise_error(NotImplementedError) }
  end
end
