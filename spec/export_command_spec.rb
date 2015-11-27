require 'export_command'

describe Outhaul::ExportCommand do

  describe '#run' do
    context 'with a valid file path' do
      let(:file) { './spec/fixtures/empty.html' }
      let(:command) { Outhaul::ExportCommand.new }

      subject { command.run file }

      it 'returns true' do
        expect(subject).to be true
      end
    end
  end

end
