require_relative "./reporting/open_data_export_test_helper"

describe "Acceptance::AssessmentAttributeValue" do
  include RSpecRegisterApiServiceMixin

  context "When lodging assessment data import into EAV and export using data pivot " do
    before(:all) do
      scheme_id = lodge_assessor
      domestic_rdsap_xml =
        get_assessment_xml(
          "RdSAP-Schema-20.0.0",
          "0000-0000-0000-0000-0001",
          test_start_date,
        )

      lodge_assessment(
        assessment_body: domestic_rdsap_xml.to_xml,
        accepted_responses: [201],
        auth_data: {
          scheme_ids: [scheme_id],
        },
        override: true,
      )
    end

    before do
      import_use_case = UseCase::ImportAssessmentAttributes.new
      import_use_case.execute
    end

    let(:export_use_case) { UseCase::ExportAssessmentAttributes.new }

    let(:pivoted_data) do
      export_use_case.execute(%w[heating_cost_potential total_floor_area], true)
    end

    let(:csv_data) { read_csv_fixture("domestic") }

    let(:headers_for_export) { csv_data.headers.map(&:downcase).uniq }

    let(:exported_data) do
      export_use_case.execute(headers_for_export, true)
    end

    it "can export the data based on the headers requested by ODC (in the .csv)" do
      expect(exported_data.count).to eq(1)
    end
  end
end
