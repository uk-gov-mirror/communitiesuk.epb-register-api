describe "Acceptance::AddressSearch::ByBuildingReference" do
  include RSpecRegisterApiServiceMixin

  def lodge_placeholder_assessment(scheme_id, assessment_id, address_id, date)
    assessment = Nokogiri.XML Samples.xml "RdSAP-Schema-20.0.0"
    address_id_node = assessment.at("UPRN")
    assessment_id_node = assessment.at("RRN")
    assessment_registration_node = assessment.at("Registration-Date")
    assessment_inspection_node = assessment.at("Inspection-Date")

    assessment_id_node.children = assessment_id
    address_id_node.children = address_id
    assessment_inspection_node.children = date
    assessment_registration_node.children = date

    lodge_assessment(
      assessment_body: assessment.to_xml,
      accepted_responses: [201],
      auth_data: { scheme_ids: [scheme_id] },
    )
  end

  context "when an address has reports lodged" do
    let(:scheme_id) { add_scheme_and_get_id }

    let(:response) do
      JSON.parse(
        address_search_by_id("RRN-0000-0000-0000-0000-0001").body,
        symbolize_names: true,
      )
    end

    before(:each) do
      add_assessor(scheme_id, "SPEC000000", VALID_ASSESSOR_REQUEST_BODY)
      lodge_placeholder_assessment(
        scheme_id,
        "0000-0000-0000-0000-0000",
        "RRN-0000-0000-0000-0000-0000",
        Date.today.prev_day(50).strftime("%Y-%m-%d"),
      )

      lodge_placeholder_assessment(
        scheme_id,
        "0000-0000-0000-0000-0001",
        "RRN-0000-0000-0000-0000-0000",
        Date.today.prev_day(1).strftime("%Y-%m-%d"),
      )

      lodge_placeholder_assessment(
        scheme_id,
        "0000-0000-0000-0000-0002",
        "RRN-0000-0000-0000-0000-0001",
        Date.today.prev_day(6).strftime("%Y-%m-%d"),
      )

      lodge_placeholder_assessment(
        scheme_id,
        "0000-0000-0000-0000-0003",
        "RRN-0000-0000-0000-0000-0002",
        Date.today.prev_day(11).strftime("%Y-%m-%d"),
      )
    end

    it "returns the address with the associated reports" do
      expect(response[:data]).to eq(
        {
          addresses: [
            {
              addressId: "RRN-0000-0000-0000-0000-0000",
              line1: "1 Some Street",
              line2: nil,
              line3: nil,
              line4: nil,
              town: "Post-Town1",
              postcode: "A0 0AA",
              source: "PREVIOUS_ASSESSMENT",
              existingAssessments: [
                {
                  assessmentId: "0000-0000-0000-0000-0001",
                  assessmentStatus: "ENTERED",
                  assessmentType: "RdSAP",
                },
                {
                  assessmentId: "0000-0000-0000-0000-0002",
                  assessmentStatus: "ENTERED",
                  assessmentType: "RdSAP",
                },
              ],
            },
          ],
        },
      )
    end

    context "with multiple assessment statuses" do
      before do
        update_assessment_status(
          assessment_id: "0000-0000-0000-0000-0000",
          assessment_status_body: { status: "CANCELLED" },
          auth_data: { scheme_ids: [scheme_id] },
          accepted_responses: [200],
        )
        update_assessment_status(
          assessment_id: "0000-0000-0000-0000-0003",
          assessment_status_body: { status: "NOT_FOR_ISSUE" },
          auth_data: { scheme_ids: [scheme_id] },
          accepted_responses: [200],
        )
      end

      it "returns the entered assessments in existing assessments" do
        expect(response[:data][:addresses][0][:existingAssessments]).to eq(
          [
            {
              assessmentId: "0000-0000-0000-0000-0001",
              assessmentStatus: "ENTERED",
              assessmentType: "RdSAP",
            },
            {
              assessmentId: "0000-0000-0000-0000-0002",
              assessmentStatus: "ENTERED",
              assessmentType: "RdSAP",
            },
          ],
        )
      end
    end

    describe "searching using an older address id" do
      let(:response) do
        JSON.parse(
          address_search_by_id("RRN-0000-0000-0000-0000-0000").body,
          symbolize_names: true,
        )
      end

      it "returns the expected amount of addresses" do
        expect(response[:data][:addresses].length).to eq 1
      end

      it "returns the expected address with the most recent assessment as the id" do
        expect(response[:data][:addresses][0]).to eq(
          {
            addressId: "RRN-0000-0000-0000-0000-0000",
            line1: "1 Some Street",
            line2: nil,
            line3: nil,
            line4: nil,
            town: "Post-Town1",
            postcode: "A0 0AA",
            source: "PREVIOUS_ASSESSMENT",
            existingAssessments: [
              {
                assessmentId: "0000-0000-0000-0000-0000",
                assessmentStatus: "ENTERED",
                assessmentType: "RdSAP",
              },
              {
                assessmentId: "0000-0000-0000-0000-0001",
                assessmentStatus: "ENTERED",
                assessmentType: "RdSAP",
              },
            ],
          },
        )
      end
    end
  end
  context "when there are no matching addresses for the ID" do
    it "returns an empty result set" do
      response =
        JSON.parse(
          address_search_by_id("RRN-1111-2222-3333-4444-5555").body,
          symbolize_names: true,
        )
      expect(response[:data][:addresses].length).to eq 0
    end
  end

  context "when the address ID is in an invalid format" do
    it "returns a validation error" do
      address_search_by_id("DOESNTEXIST", [422])
    end
  end

  context "when an address has reports lodged using UPRN" do
    let(:scheme_id) { add_scheme_and_get_id }

    let(:response) do
      JSON.parse(
        address_search_by_id("UPRN-000000000001").body,
        symbolize_names: true,
      )
    end

    before(:each) do
      ActiveRecord::Base.connection.execute(
        "INSERT INTO address_base (uprn, address_line1, postcode, town) VALUES ('1', '1 Some Street', 'A0 0AA', 'Post-Town1')",
      )
      add_assessor(scheme_id, "SPEC000000", VALID_ASSESSOR_REQUEST_BODY)
    end

    it "returns the address" do
      expect(response[:data]).to eq(
        {
          addresses: [
            {
              addressId: "UPRN-000000000001",
              line1: "1 Some Street",
              line2: nil,
              line3: nil,
              line4: nil,
              town: "Post-Town1",
              postcode: "A0 0AA",
              source: "GAZETTEER",
              existingAssessments: [],
            },
          ],
        },
      )
    end

    it "returns the address with the associated reports" do
      lodge_placeholder_assessment(
        scheme_id,
        "0000-0000-0000-0000-0000",
        "UPRN-000000000001",
        Date.today.prev_day(50).strftime("%Y-%m-%d"),
      )

      expect(response[:data]).to eq(
        {
          addresses: [
            {
              addressId: "UPRN-000000000001",
              line1: "1 Some Street",
              line2: nil,
              line3: nil,
              line4: nil,
              town: "Post-Town1",
              postcode: "A0 0AA",
              source: "GAZETTEER",
              existingAssessments: [
                {
                  assessmentId: "0000-0000-0000-0000-0000",
                  assessmentStatus: "ENTERED",
                  assessmentType: "RdSAP",
                },
              ],
            },
          ],
        },
      )
    end
  end

  context "when address_line1 is blank" do
    let(:scheme_id) { add_scheme_and_get_id }

    it "populates with address line 3" do
      assessment = Nokogiri.XML Samples.xml "CEPC-8.0.0", "cepc"
      address_id = assessment.at("//CEPC:UPRN")
      assessment_id = assessment.at("//CEPC:RRN")

      address_line_one = assessment.at("//CEPC:Address-Line-1")
      address_line_two = Nokogiri::XML::Node.new "Address-Line-2", assessment
      address_line_three = Nokogiri::XML::Node.new "Address-Line-3", assessment

      address_line_one.content = ""
      address_line_two.content = ""
      address_line_three.content = "This is Address line 3"

      address_line_one.add_next_sibling address_line_two
      address_line_two.add_next_sibling address_line_three

      assessment_id.children = "0000-0000-0000-0000-0000"
      address_id.children = "RRN-0000-0000-0000-0000-0000"

      add_assessor(
        scheme_id,
        "SPEC000000",
        AssessorStub.new.fetch_request_body(
          nonDomesticNos3: "ACTIVE",
          nonDomesticNos4: "ACTIVE",
          nonDomesticNos5: "ACTIVE",
        ),
      )

      lodge_assessment(
        assessment_body: assessment.to_xml,
        accepted_responses: [201],
        schema_name: "CEPC-8.0.0",
        auth_data: { scheme_ids: [scheme_id] },
      )

      response =
        JSON.parse(
          address_search_by_id("RRN-0000-0000-0000-0000-0000").body,
          symbolize_names: true,
        )

      expect(response[:data][:addresses][0][:line1]).to eq(
        "This is Address line 3",
      )
    end
  end
end
