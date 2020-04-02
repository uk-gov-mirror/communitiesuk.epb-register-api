# frozen_string_literal: true

describe 'Acceptance::LodgeDomesticEnergyAssessment' do
  include RSpecAssessorServiceMixin

  let(:valid_xml) do
    #File.join File.dirname(__dir__), '../../lib/schemas/xml/examples/RdSAP-19.01.xml'
    File.read File.join Dir.pwd, 'api/schemas/xml/examples/RdSAP-19.01.xml'
    #File.read File.join(Dir.pwd, 'spec/unit/helper/xml/example.xml')
    #File.join File.dirname(__dir__), '../unit/helper/xml/example.xml'
  end

  context 'when lodging a domestic assessment (post)' do
    it 'returns 401 with no authentication' do
      lodge_assessment('123-456', 'body', [401], false)
    end

    it 'returns 403 with incorrect scopes' do
      lodge_assessment('123-456', 'body', [403], true, {}, %w[wrong:scope])
    end

    it 'returns status 201' do
      lodge_assessment('123-456', 'body', [201])
    end

    it 'returns json' do
      response = lodge_assessment('123-456', 'body', [201])
      expect(response.headers['Content-Type']).to eq('application/json')
    end

    it 'returns the assessment in the correct format' do
      response = lodge_assessment('123-456', valid_xml, [201])

      expect(response).to eq({})
    end
  end
end
