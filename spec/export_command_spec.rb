require 'export_command'

describe Outhaul::ExportCommand do

  describe '#run' do
    let(:file) { '/dev/null' }
    let(:options) { {api_token: '0000', project_id: '0000' } }
    let(:export_command) { Outhaul::ExportCommand.new options }
    let(:epic_endpoint) { TrackerApi::Endpoints::Epic }
    let(:epic_resource) { TrackerApi::Resources::Epic }
    let(:story_endpoint) { TrackerApi::Endpoints::Story }
    let(:story_resource) { TrackerApi::Resources::Story }
    let(:html) { '' }

    subject(:command) { export_command.run file }

    before do
      allow_any_instance_of(epic_endpoint).to receive(:create) do |instance, object, project_id, params|
        epic.name = params[:name] unless params.nil?
        epic
      end
      allow_any_instance_of(epic_resource).to receive(:save)

      allow_any_instance_of(story_endpoint).to receive(:create) do |instance, object, project_id, params|
        story.name = params[:name]
        story
      end
      allow_any_instance_of(story_resource).to receive(:save)

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

      context 'without a label specified' do
        let(:params) { {name: epic_name} }

        it 'does not send a label param when creating the epic' do
          expect_any_instance_of(epic_endpoint).to receive(:create).with('0000', params)
          result
        end

      end

    end

    context 'with a Document containing a H2' do
      let(:story) { story_resource.new }
      let(:story_name) { 'This is an Story Name' }
      let(:html) { "<h2>#{story_name}</h2>" }

      subject(:result) do
        command
        story
      end

      it 'creates an Epic with a name matching the H1 text' do
        expect_any_instance_of(story_endpoint).to receive(:create)
        expect(result.name).to eq story_name
      end

    end
  end

end
