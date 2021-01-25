describe UseCase::ExportOpenDataCommercial do
  include RSpecRegisterApiServiceMixin


  context "when creating the open data reporting release" do
    describe "for the commercial certificates and reports" do

      let(:number_assessments_to_test) {2}

      before(:all) do
        scheme_id =   add_scheme_and_get_id
        non_domestic_xml =  Nokogiri.XML Samples.xml("CEPC-8.0.0", "cepc")
        non_domestic_assessment_id =   non_domestic_xml.at("//CEPC:RRN")
        non_domestic_assessment_date = non_domestic_xml.at("//CEPC:Registration-Date")

        # Lodge a dec to ensure it is not exported
        domestic_xml =   Nokogiri.XML Samples.xml("CEPC-8.0.0", "dec")
        domestic_assessment_id= domestic_xml.at("RRN")
        domestic_assessment_date =  domestic_xml.at("Registration-Date")


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

        non_domestic_assessment_date.children = "2020-05-04"
        lodged =
          lodge_assessment(
            assessment_body: non_domestic_xml.to_xml,
            accepted_responses: [201],
            auth_data: { scheme_ids: [scheme_id] },
            override: true,
            schema_name: "CEPC-8.0.0",
          )

        non_domestic_assessment_date.children = "2018-05-04"
        non_domestic_assessment_id.children = "0000-0000-0000-0000-0001"
        lodge_assessment(
          assessment_body: non_domestic_xml.to_xml,
          accepted_responses: [201],
          auth_data: { scheme_ids: [scheme_id] },
          override: true,
          schema_name: "CEPC-8.0.0",
        )

        domestic_assessment_date.children = "2018-05-04"
        domestic_assessment_id.children = "0000-0000-0000-0000-0005"
        lodge_assessment(
          assessment_body: domestic_xml.to_xml,
          accepted_responses: [201],
          auth_data: { scheme_ids: [scheme_id] },
          override: true,
          schema_name: "CEPC-8.0.0",
          )


      end

      let(:exported_data) do described_class.new.execute end

      let(:date_today) { DateTime.now.strftime("%F") }
      let(:expected_values) do
        Samples::ViewModels::Cepc.report_test_hash.merge(
          { lodgement_date: date_today},
        )
      end
      let(:expected_values_row_1) do
        Samples.update_test_hash(
          expected_values,
          {
            rrn: "0000-0000-0000-0000-0001",
            lodgement_date: date_today,

          },
        )
      end



      it "returns the correct number of assessments in the CSV" do
        expect(exported_data.length).to eq(number_assessments_to_test)
      end


      # 1st row to test
      # write at test for each key in test hash
      Samples::ViewModels::Cepc
        .report_test_hash
        .keys
        .each do |index|
          it "returns the #{
               index
             } that matches the test data for the 1st row" do
            expect(exported_data[0][index.to_sym]).to eq(
              expected_values[index],
            )
          end
      end


      # 2nd row to test
      #write at test for each key in test hash
      Samples::ViewModels::Cepc
          .report_test_hash
          .keys
          .each do |index|
          it "returns the #{
            index
          } that matches the test data for the 1st row" do
            expect(exported_data[1][index.to_sym]).to eq(expected_values_row_1[index])
          end
        end
    end
  end
end
