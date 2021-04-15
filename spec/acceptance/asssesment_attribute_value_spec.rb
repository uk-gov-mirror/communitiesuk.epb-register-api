require_relative "./reporting/open_data_export_test_helper"

describe "Acceptance::AssessmentAttributeValue" do
  include RSpecRegisterApiServiceMixin

  context "lodge an assessment from the xml " do
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
      export_use_case.execute(
        %w[assessment_id heating_cost_potential total_floor_area],
      )
    end

    it "will contain a row for one assesment" do
      expect(pivoted_data.length).to eq(1)
      expect(pivoted_data.first["assessment_id"]).to eq(
        "0000-0000-0000-0000-0001",
      )
      expect(pivoted_data.first["heating_cost_potential"]).to eq("250.34")
    end

    let(:csv_data) { read_csv_fixture("domestic") }

    let(:headers_for_export) { csv_data.headers.map(&:downcase).uniq }

    it "can export the data based on the headers as request by ODC (in the .csv)" do
      expect(export_use_case.execute(headers_for_export).count).to eq(1)
    end
  end
end
