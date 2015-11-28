require 'export_command'

describe Outhaul::ExportCommand do

  describe '#run' do
    let(:file) { '/dev/null' }
    let(:options) { {api_token: '0000', project_id: '0000' } }
    let(:export_command) { Outhaul::ExportCommand.new options }
    let(:epic_endpoint) { TrackerApi::Endpoints::Epic }
    let(:epic_resource) { TrackerApi::Resources::Epic }
    let(:html) { '' }

    subject(:command) { export_command.run file }

    before do
      allow_any_instance_of(epic_endpoint).to receive(:create) do |instance, object, project_id, params|
        epic.name = params[:name]
        epic
      end

      allow_any_instance_of(epic_resource).to receive(:save)

      allow(IO).to receive(:read).and_return(html)
    end

    context 'successful execution' do
      it 'returns true' do
        expect(command).to be true
      end
    end

    context 'with a Document containing a H1' do
      let(:epic) { epic_resource.new }
      let(:epic_name) { 'This is an Epic Name' }
      let(:html) { "<h1>#{epic_name}</h1>" }

      subject(:result) do
        command
        epic
      end

      it 'creates an Epic with a name matching the H1 text' do
        expect_any_instance_of(epic_endpoint).to receive(:create)
        expect(result.name).to eq epic_name
      end

    end
  end

end
