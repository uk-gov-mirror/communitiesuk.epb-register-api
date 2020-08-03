# frozen_string_literal: true

describe "Acceptance::AssessmentSummary::DEC" do
  include RSpecRegisterApiServiceMixin

  context "when a valid DEC 8.0.0 is lodged" do
    let(:xml_file) do
      File.read File.join Dir.pwd, "spec/fixtures/samples/dec.xml"
    end
    let(:scheme_id) { add_scheme_and_get_id }
    let(:response) do
      JSON.parse(
        fetch_assessment_summary("0000-0000-0000-0000-0000").body,
        symbolize_names: true,
      )
    end

    before do
      assessor = AssessorStub.new.fetch_request_body(nonDomesticDec: "ACTIVE")

      add_assessor(scheme_id, "SPEC000000", assessor)
      lodge_assessment(
        assessment_body: xml_file,
        auth_data: { scheme_ids: [scheme_id] },
        schema_name: "CEPC-8.0.0",
      )
    end

    it "returns the assessment" do
      expect(response[:data]).to eq(
        {
          typeOfAssessment: "DEC",
          assessmentId: "0000-0000-0000-0000-0000",
          reportType: "1",
          dateOfExpiry: "2026-05-04",
          energyEfficiencyBand: "a",
          energyEfficiencyRating: "1",
          address: {
            addressId: "UPRN-000000000001",
            addressLine1: "2 Lonely Street",
            addressLine2: nil,
            addressLine3: nil,
            addressLine4: nil,
            town: "Post-Town1",
            postcode: "A0 0AA",
          },
        },
      )
    end
  end
end