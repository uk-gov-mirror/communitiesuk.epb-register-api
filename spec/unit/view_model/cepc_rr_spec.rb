require_relative 'xml_view_test_helper'

describe ViewModel::CepcRr::CepcRrWrapper do
  context "Testing the CEPC-RR schemas" do
    # You should only need to add to this list to test new CEPC schema
    supported_schema = [
      {
        schema_name: "CEPC-8.0.0",
        xml_file: "spec/fixtures/samples/cepc-rr.xml",
        unsupported_fields: [],
      },
    ].freeze

    # You should only need to add to this list to test new fields on all CEPC schema
    asserted_keys = {
      assessment_id: "0000-0000-0000-0000-0000",
      report_type: "4",
      type_of_assessment: "CEPC-RR",
      date_of_expiry: "2021-05-03",
      address: {
        address_id: "UPRN-000000000000",
        address_line1: "1 Lonely Street",
        address_line2: nil,
        address_line3: nil,
        address_line4: nil,
        town: "Post-Town0",
        postcode: "A0 0AA",
      },
      assessor: { scheme_assessor_id: "SPEC000000", name: "Mrs Report Writer" },
      short_payback_recommendations: [
        {
          code: "1",
          text: "Consider replacing T8 lamps with retrofit T5 conversion kit.",
          cO2Impact: "HIGH",
        },
        {
          code: "3",
          text:
            "Introduce HF (high frequency) ballasts for fluorescent tubes: Reduced number of fittings required.",
          cO2Impact: "LOW",
        },
      ],
      medium_payback_recommendations: [
        {
          code: "2",
          text: "Add optimum start/stop to the heating system.",
          cO2Impact: "MEDIUM",
        },
      ],
      long_payback_recommendations: [
        {
          code: "3",
          text: "Consider installing an air source heat pump.",
          cO2Impact: "HIGH",
        },
      ],
      other_recommendations: [
        { code: "4", text: "Consider installing PV.", cO2Impact: "HIGH" },
      ],
    }.freeze

    it "should read the appropriate values from the XML doc" do
      test_xml_doc(ViewModel::CepcRr::CepcRrWrapper, supported_schema, asserted_keys)
    end

    it "returns the expect error without a valid schema type" do
      expect {
        ViewModel::CepcRr::CepcRrWrapper.new "", "invalid"
      }.to raise_error.with_message "Unsupported schema type"
    end
  end
end
