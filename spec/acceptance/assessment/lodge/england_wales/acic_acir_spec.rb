# frozen_string_literal: true

describe "Acceptance::LodgeACICEnergyAssessment" do
  include RSpecAssessorServiceMixin

  let(:fetch_assessor_stub) { AssessorStub.new }

  let(:valid_cepc_ni_xml) do
    File.read File.join Dir.pwd,
                        "api/schemas/xml/examples/CEPC-7.11(ACIC+ACIR).xml"
  end

  context "when lodging an ACIC+ACIR assessment (post)" do
    context "when an assessor is inactive" do
      let(:scheme_id) { add_scheme_and_get_id }

      context "when unqualified for ACIC" do
        it "returns status 400 with the correct error response" do
          add_assessor(
            scheme_id,
            "JASE000000",
            fetch_assessor_stub.fetch_request_body(
              nonDomesticCc4: "INACTIVE", nonDomesticSp3: "ACTIVE",
            ),
          )

          response =
            JSON.parse(
              lodge_assessment(
                assessment_body: valid_cepc_ni_xml,
                accepted_responses: [400],
                auth_data: { scheme_ids: [scheme_id] },
                schema_name: "CEPC-7.1",
              )
                .body,
            )

          expect(response["errors"][0]["title"]).to eq(
            "Assessor is not active.",
          )
        end
      end

      context "when unqualified for ACIR" do
        it "returns status 400 with the correct error response" do
          add_assessor(
            scheme_id,
            "JASE000000",
            fetch_assessor_stub.fetch_request_body(
              nonDomesticCc4: "ACTIVE", nonDomesticSp3: "INACTIVE",
            ),
          )
          response =
            JSON.parse(
              lodge_assessment(
                assessment_body: valid_cepc_ni_xml,
                accepted_responses: [400],
                auth_data: { scheme_ids: [scheme_id] },
                schema_name: "CEPC-7.1",
              )
                .body,
            )

          expect(response["errors"][0]["title"]).to eq(
            "Assessor is not active.",
          )
        end
      end
    end

    it "returns status 201" do
      scheme_id = add_scheme_and_get_id
      add_assessor(
        scheme_id,
        "JASE000000",
        fetch_assessor_stub.fetch_request_body(
          nonDomesticCc4: "ACTIVE", nonDomesticSp3: "ACTIVE",
        ),
      )

      lodge_assessment(
        assessment_body: valid_cepc_ni_xml,
        accepted_responses: [201],
        auth_data: { scheme_ids: [scheme_id] },
        schema_name: "CEPC-7.1",
      )
    end

    context "when saving a (ACIC+ACIR) assessment" do
      let(:scheme_id) { add_scheme_and_get_id }
      let(:doc) { Nokogiri.XML valid_cepc_ni_xml }
      let(:response_acic) do
        JSON.parse(fetch_assessment("9876-5432-0987-7654-4321").body)
      end
      let(:response_acir) do
        JSON.parse(fetch_assessment("0250-4986-0585-2040-9030").body)
      end

      before do
        add_assessor(
          scheme_id,
          "JASE000000",
          fetch_assessor_stub.fetch_request_body(
            nonDomesticCc4: "ACTIVE", nonDomesticSp3: "ACTIVE",
          ),
        )
      end

      it "returns the data that was lodged" do
        lodge_assessment(
          assessment_body: doc.to_xml,
          accepted_responses: [201],
          auth_data: { scheme_ids: [scheme_id] },
          schema_name: "CEPC-7.1",
        )

        expected_acic_response = {
          "addressLine1" => "A. Shop",
          "addressLine2" => "The High Street",
          "addressLine3" => "",
          "addressLine4" => "",
          "assessmentId" => "9876-5432-0987-7654-4321",
          "assessor" => {
            "contactDetails" => {
              "email" => "person@person.com",
              "telephoneNumber" => "010199991010101",
            },
            "dateOfBirth" => "1991-02-25",
            "firstName" => "Someone",
            "lastName" => "Person",
            "middleNames" => "Muddle",
            "qualifications" => {
              "domesticSap" => "INACTIVE",
              "domesticRdSap" => "INACTIVE",
              "nonDomesticCc4" => "ACTIVE",
              "nonDomesticSp3" => "ACTIVE",
              "nonDomesticDec" => "INACTIVE",
              "nonDomesticNos3" => "INACTIVE",
              "nonDomesticNos4" => "INACTIVE",
              "nonDomesticNos5" => "INACTIVE",
              "gda" => "INACTIVE",
            },
            "address" => {},
            "companyDetails" => {},
            "registeredBy" => {
              "name" => "test scheme", "schemeId" => scheme_id
            },
            "schemeAssessorId" => "JASE000000",
            "searchResultsComparisonPostcode" => "",
          },
          "currentCarbonEmission" => 0.0,
          "currentEnergyEfficiencyBand" => "a",
          "currentEnergyEfficiencyRating" => 99,
          "optOut" => false,
          "dateOfAssessment" => "2019-05-20",
          "dateOfExpiry" => "2020-05-19",
          "dateRegistered" => "2019-05-20",
          "dwellingType" => nil,
          "heatDemand" => {
            "currentSpaceHeatingDemand" => 0.0,
            "currentWaterHeatingDemand" => 0.0,
            "impactOfCavityInsulation" => nil,
            "impactOfLoftInsulation" => nil,
            "impactOfSolidWallInsulation" => nil,
          },
          "postcode" => "AB12 2AA",
          "potentialCarbonEmission" => 0.0,
          "potentialEnergyEfficiencyBand" => "a",
          "potentialEnergyEfficiencyRating" => 99,
          "totalFloorArea" => 99.0,
          "town" => "London",
          "typeOfAssessment" => "ACIC",
          "relatedPartyDisclosureNumber" => nil,
          "relatedPartyDisclosureText" => nil,
          "recommendedImprovements" => [],
          "propertySummary" => [],
        }

        expect(response_acic["data"]).to eq(expected_acic_response)

        expected_acir_response = {
          "addressLine1" => "A. Shop",
          "addressLine2" => "The High Street",
          "addressLine3" => "",
          "addressLine4" => "",
          "assessmentId" => "0250-4986-0585-2040-9030",
          "assessor" => {
            "contactDetails" => {
              "email" => "person@person.com",
              "telephoneNumber" => "010199991010101",
            },
            "dateOfBirth" => "1991-02-25",
            "firstName" => "Someone",
            "lastName" => "Person",
            "middleNames" => "Muddle",
            "qualifications" => {
              "domesticSap" => "INACTIVE",
              "domesticRdSap" => "INACTIVE",
              "nonDomesticCc4" => "ACTIVE",
              "nonDomesticSp3" => "ACTIVE",
              "nonDomesticDec" => "INACTIVE",
              "nonDomesticNos3" => "INACTIVE",
              "nonDomesticNos4" => "INACTIVE",
              "nonDomesticNos5" => "INACTIVE",
              "gda" => "INACTIVE",
            },
            "address" => {},
            "companyDetails" => {},
            "registeredBy" => {
              "name" => "test scheme", "schemeId" => scheme_id
            },
            "schemeAssessorId" => "JASE000000",
            "searchResultsComparisonPostcode" => "",
          },
          "currentCarbonEmission" => 0.0,
          "currentEnergyEfficiencyBand" => "a",
          "currentEnergyEfficiencyRating" => 99,
          "optOut" => false,
          "dateOfAssessment" => "2019-05-20",
          "dateOfExpiry" => "2020-05-19",
          "dateRegistered" => "2019-05-20",
          "dwellingType" => nil,
          "heatDemand" => {
            "currentSpaceHeatingDemand" => 0.0,
            "currentWaterHeatingDemand" => 0.0,
            "impactOfCavityInsulation" => nil,
            "impactOfLoftInsulation" => nil,
            "impactOfSolidWallInsulation" => nil,
          },
          "postcode" => "AB12 2AA",
          "potentialCarbonEmission" => 0.0,
          "potentialEnergyEfficiencyBand" => "a",
          "potentialEnergyEfficiencyRating" => 99,
          "totalFloorArea" => 99.0,
          "town" => "London",
          "typeOfAssessment" => "ACIR",
          "relatedPartyDisclosureNumber" => nil,
          "relatedPartyDisclosureText" => nil,
          "recommendedImprovements" => [],
          "propertySummary" => [],
        }

        expect(response_acir["data"]).to eq(expected_acir_response)
      end
    end

    context "when failing so save ACIR as ACIC went through" do
      let(:scheme_id) { add_scheme_and_get_id }

      before do
        add_assessor(
          scheme_id,
          "JASE000000",
          fetch_assessor_stub.fetch_request_body(
            nonDomesticCc4: "ACTIVE", nonDomesticSp3: "INACTIVE",
          ),
        )
      end

      it "does not save any lodgement" do
        lodge_assessment(
          assessment_body: valid_cepc_ni_xml,
          accepted_responses: [400],
          auth_data: { scheme_ids: [scheme_id] },
          schema_name: "CEPC-7.1",
        )

        fetch_assessment("9876-5432-0987-7654-4321", [404])

        fetch_assessment("0250-4986-0585-2040-9030", [404])
      end
    end
  end
end