describe "Acceptance::AssessmentStatus" do
  include RSpecAssessorServiceMixin

  let(:fetch_assessor_stub) { AssessorStub.new }

  let(:valid_rdsap_xml) do
    File.read File.join Dir.pwd, "spec/fixtures/samples/rdsap.xml"
  end

  context "security" do
    context "when cancelling an assessment" do
      it "rejects a request that is not authenticated" do
        update_assessment_status assessment_id: "0000-0000-0000-0000-0000",
                                 assessment_status_body: {
                                   status: "CANCELLED",
                                 },
                                 accepted_responses: [401],
                                 authenticate: false
      end

      it "rejects a request with the wrong scopes" do
        update_assessment_status assessment_id: "0000-0000-0000-0000-0000",
                                 assessment_status_body: {
                                   status: "CANCELLED",
                                 },
                                 accepted_responses: [403],
                                 scopes: %w[wrong:scope]
      end
    end

    context "when making an assessment not for issue" do
      it "rejects a request that is not authenticated" do
        update_assessment_status assessment_id: "0000-0000-0000-0000-0000",
                                 assessment_status_body: {
                                   status: "NOT_FOR_ISSUE",
                                 },
                                 accepted_responses: [401],
                                 authenticate: false

        fetch_assessment("123", [401], false)
      end

      it "rejects a request with the wrong scopes" do
        update_assessment_status assessment_id: "0000-0000-0000-0000-0000",
                                 assessment_status_body: {
                                   status: "NOT_FOR_ISSUE",
                                 },
                                 accepted_responses: [403],
                                 scopes: %w[wrong:scope]
      end
    end

    context "when updating an assessment status that doesn't belong to the scheme" do
      it "then gives error 403 and the correct error message" do
        scheme_id = add_scheme_and_get_id
        add_assessor(
          scheme_id,
          "SPEC000000",
          fetch_assessor_stub.fetch_request_body(domesticRdSap: "ACTIVE"),
        )

        lodge_assessment(
          assessment_body: valid_rdsap_xml,
          accepted_responses: [201],
          auth_data: { scheme_ids: [scheme_id] },
        )

        assessment_update_response =
          JSON.parse(
            update_assessment_status(
              assessment_id: "0000-0000-0000-0000-0000",
              assessment_status_body: { "status": "NOT_FOR_ISSUE" },
              accepted_responses: [403],
              auth_data: { scheme_ids: [scheme_id + 1] },
            ).body,
            symbolize_names: true,
          )

        expect(assessment_update_response[:errors][0][:code]).to eq(
          "NOT_ALLOWED",
        )
      end
    end
  end
end
