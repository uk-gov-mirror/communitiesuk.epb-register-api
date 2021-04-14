def test_start_date
  "2021-02-22"
end

def get_assessment_xml(schema, id, date_registered, type = "")
  xml =
    if type.empty?
      Nokogiri.XML(Samples.xml(schema))
    else
      Nokogiri.XML(Samples.xml(schema, type))
    end
  assessment_id_node =
    type == "cepc" ? xml.at("//*[local-name() = 'RRN']") : xml.at("RRN")
  assessment_id_node.children = id
  xml.at("//*[local-name() = 'Registration-Date']").children = date_registered
  xml
end

def lodge_assessor
  scheme_id = add_scheme_and_get_id
  add_assessor(
    scheme_id,
    "SPEC000000",
    AssessorStub.new.fetch_request_body(
      nonDomesticNos3: "ACTIVE",
      nonDomesticNos4: "ACTIVE",
      nonDomesticNos5: "ACTIVE",
      nonDomesticDec: "ACTIVE",
      domesticRdSap: "ACTIVE",
      domesticSap: "ACTIVE",
      nonDomesticSp3: "ACTIVE",
      nonDomesticCc4: "ACTIVE",
      gda: "ACTIVE",
    ),
  )
  scheme_id
end

describe UseCase::ImportAssessmentAttributes do
  include RSpecRegisterApiServiceMixin

  context "lodge an assessment from the xml " do
    before(:all) do
      scheme_id = lodge_assessor
      domestic_rdsap_xml =
        get_assessment_xml(
          "RdSAP-Schema-20.0.0",
          "0000-0000-0000-0000-0004",
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

    let(:import_use_case) { UseCase::ImportAssessmentAttributes.new }

    let(:attributes) do
      ActiveRecord::Base.connection.exec_query(
        "SELECT * FROM assessment_attributes",
      )
    end

    it "reads the xml data from the lodgment" do
      expect(import_use_case.execute("0000-0000-0000-0000-0004")).to be_a(Hash)
    end

    it "checks the database for the inserted attributes" do
      expect(import_use_case.execute("0000-0000-0000-0000-0004")).to be_a(Hash)
      expect(
        ActiveRecord::Base
          .connection
          .exec_query(
            "SELECT attribute_name FROM assessment_attributes WHERE attribute_name= 'heating_cost_potential'",
          )
          .rows
          .first,
      ).to eq(%w[heating_cost_potential])

      expect(
        ActiveRecord::Base
          .connection
          .exec_query(
            "SELECT attribute_name FROM assessment_attributes WHERE attribute_name= 'total_floor_area'",
          )
          .rows
          .first,
      ).to eq(%w[total_floor_area])
    end
  end
end
