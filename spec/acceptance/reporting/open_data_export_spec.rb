require_relative "open_data_export_test_helper"

describe "Acceptance::Reports::OpenDataExport" do
  include RSpecRegisterApiServiceMixin

  before(:all) { @scheme_id = lodge_assessor }

  after { WebMock.disable! }

  let(:statistics) do
    gateway = Gateway::OpenDataLogGateway.new
    gateway.fetch_latest_statistics
  end

  context "When an assessment is lodged" do
    context "And it is a domestic assessment" do
      before(:all) do
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
            scheme_ids: [@scheme_id],
          },
          override: true,
        )

        domestic_rdsap_xml =
          get_assessment_xml(
            "RdSAP-Schema-20.0.0",
            "0000-0000-0000-0000-1004",
            test_to_date,
          )
        lodge_assessment(
          assessment_body: domestic_rdsap_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
        )

        domestic_sap_xml =
          get_assessment_xml(
            "SAP-Schema-18.0.0",
            "0000-0000-0000-0000-1100",
            test_start_date,
          )
        domestic_sap_building_reference_number = domestic_sap_xml.at("UPRN")
        domestic_sap_building_reference_number.children =
          "RRN-0000-0000-0000-0000-0023"
        lodge_assessment(
          assessment_body: domestic_sap_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "SAP-Schema-18.0.0",
        )
      end

      context "Then it calls the use case to extract the data" do
        context "for the domestic certificates" do
          let(:use_case) { UseCase::ExportOpenDataDomestic.new }
          let(:csv_data) do
            Helper::ExportHelper.to_csv(
              use_case
                .execute(test_start_date, 0, "2021-02-28")
                .sort_by! { |item| item[:assessment_id] },
            )
          end
          let(:fixture_csv) { read_csv_fixture("domestic") }
          let(:parsed_exported_data) { CSV.parse(csv_data, headers: true) }

          it "returns the data exported to a csv object to match the .csv fixture" do
            expect(parsed_exported_data.length).to eq(fixture_csv.length)
            expect(parsed_exported_data.headers - fixture_csv.headers).to eq([])
          end

          2.times do |i|
            it "returns the data exported for row #{i} object to match same row in the .csv fixture " do
              expect(
                redact_lodgement_datetime(parsed_exported_data[i]) -
                  redact_lodgement_datetime(fixture_csv[i]),
              ).to eq([])
            end
          end

          context "when there are no lodged assessments between two dates" do
            let(:csv_data) do
              Helper::ExportHelper.to_csv(
                use_case
                  .execute("2021-03-02", 0, "2021-03-03")
                  .sort_by! { |item| item[:assessment_id] },
              )
            end

            it "returns no data" do
              expect(csv_data.length).to eq(0)
            end
          end
        end

        context "for the domestic recommendation reports" do
          let(:use_case) { UseCase::ExportOpenDataDomesticrr.new }
          let(:csv_data) do
            Helper::ExportHelper.to_csv(
              use_case
                .execute(test_start_date, 0, "2021-02-28")
                .sort_by! do |item|
                  [item[:assessment_id], item[:improvement_item]]
                end,
            )
          end
          let(:fixture_csv) { read_csv_fixture("domestic_rr") }
          let(:parsed_exported_data) { CSV.parse(csv_data, headers: true) }

          it "returns the data exported to a csv object to match the .csv fixture" do
            expect(parsed_exported_data.headers - fixture_csv.headers).to eq([])
            expect(parsed_exported_data.length).to eq(fixture_csv.length)
          end

          4.times do |i|
            it "returns the data exported for row #{i} object to match same row in the .csv fixture " do
              expect(parsed_exported_data[i].to_a - fixture_csv[i].to_a).to eq(
                [],
              )
            end
          end

          context "when there are no lodged assessments between two dates" do
            let(:csv_data) do
              Helper::ExportHelper.to_csv(
                use_case
                  .execute("2021-03-02", 0, "2021-03-03")
                  .sort_by! { |item| item[:assessment_id] },
              )
            end

            it "returns no data" do
              expect(csv_data.length).to eq(0)
            end
          end
        end
      end

      context "Then we invoke the Open Data Communities export Rake directly" do
        context "And we set the correct environment variables to send the certificate data to S3" do
          before do
            EnvironmentStub
              .all
              .with("DATE_FROM", test_start_date)
              .with("ASSESSMENT_TYPE", "SAP-RDSAP")
              .with("DATE_TO", "2021-03-29")

            HttpStub.s3_put_csv(file_name("SAP-RDSAP"))
          end
          let(:fixture_csv) { read_csv_fixture("domestic") }

          it "check the http stub matches the request disabled in web mock using the filename, body and headers " do
            get_task("open_data_export").invoke

            expect(WebMock).to have_requested(
              :put,
              "#{HttpStub::S3_BUCKET_URI}open_data_export_sap-rdsap_#{DateTime.now.strftime('%F')}_1.csv",
            ).with(
              body: regex_body(fixture_csv.headers),
              headers: {
                "Host" => "s3.eu-west-2.amazonaws.com",
              },
            )
          end
        end

        context "And we set correct environment variables to send the recommendation report data to S3" do
          before do
            EnvironmentStub
              .all
              .with("DATE_FROM", test_start_date)
              .with("ASSESSMENT_TYPE", "SAP-RDSAP-RR")
              .except("DATE_TO")

            HttpStub.s3_put_csv(file_name("SAP-RDSAP-RR"))
          end
          let(:fixture_csv) { read_csv_fixture("domestic_rr") }

          it "check the http stub matches the request disabled in web mock using the filename, body and headers" do
            get_task("open_data_export").invoke

            expect(WebMock).to have_requested(
              :put,
              "#{HttpStub::S3_BUCKET_URI}open_data_export_sap-rdsap-rr_#{DateTime.now.strftime('%F')}_1.csv",
            ).with(
              body: regex_body(fixture_csv.headers),
              headers: {
                "Host" => "s3.eu-west-2.amazonaws.com",
              },
            )
          end
        end
      end
    end

    context "And it is a commercial/non-domestic assessment" do
      before(:all) do
        2.times do |i|
          non_domestic_xml =
            get_assessment_xml(
              "CEPC-8.0.0",
              "0000-0000-0000-0000-000#{i}",
              test_start_date,
              "cepc",
            )
          lodge_assessment(
            assessment_body: non_domestic_xml.to_xml,
            accepted_responses: [201],
            auth_data: {
              scheme_ids: [@scheme_id],
            },
            override: true,
            schema_name: "CEPC-8.0.0",
          )
        end

        out_of_range_non_domestic_xml =
          get_assessment_xml(
            "CEPC-8.0.0",
            "0000-0000-0000-0000-0010",
            test_to_date,
            "cepc",
          )
        lodge_assessment(
          assessment_body: out_of_range_non_domestic_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "CEPC-8.0.0",
        )

        cepc_rr_xml =
          get_recommendations_xml(
            "CEPC-8.0.0",
            test_start_date,
            "cepc+rr",
            "1111",
          )
        lodge_assessment(
          assessment_body: cepc_rr_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "CEPC-8.0.0",
        )

        cepc_rr_xml =
          get_recommendations_xml("CEPC-8.0.0", test_to_date, "cepc+rr", "1112")
        lodge_assessment(
          assessment_body: cepc_rr_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "CEPC-8.0.0",
        )
      end

      context "Then it calls the use case to extract the data" do
        context "for the commercial/non-domestic certificates" do
          let(:use_case) { UseCase::ExportOpenDataCommercial.new }

          let(:csv_data) do
            Helper::ExportHelper.to_csv(
              use_case.execute(test_start_date, 0, "2021-02-28"),
            )
          end

          let(:fixture_csv) { read_csv_fixture("commercial") }

          let(:parsed_exported_data) { CSV.parse(csv_data, headers: true) }

          let(:first_commercial_assessment) do
            parsed_exported_data.find do |item|
              item["ASSESSMENT_ID"] ==
                "4af9d2c31cf53e72ef6f59d3f59a1bfc500ebc2b1027bc5ca47361435d988e1a"
            end
          end

          let(:second_commercial_assessment) do
            parsed_exported_data.find do |item|
              item["ASSESSMENT_ID"] ==
                "55ce7d026c13e923d26cbfb0d6ed60734d3270ba981d629a168bb8eb2da3f8c4"
            end
          end

          it "returns the data exported to a csv object to match the .csv fixture" do
            expect(fixture_csv.headers - parsed_exported_data.headers).to eq([])
            expect(parsed_exported_data.length).to eq(3)
          end

          it "returns the data exported for row 1 object to match same row in the .csv fixture " do
            expect(
              redact_lodgement_datetime(first_commercial_assessment) -
                redact_lodgement_datetime(fixture_csv[0]),
            ).to eq([])
          end

          it "returns the data exported for row 2 object to match same row in the .csv fixture " do
            expect(
              redact_lodgement_datetime(second_commercial_assessment) -
                redact_lodgement_datetime(fixture_csv[1]),
            ).to eq([])
          end
        end

        context "for the commercial/non Domestic recommendation reports" do
          let(:use_case) { UseCase::ExportOpenDataCepcrr.new }
          let(:csv_data) do
            Helper::ExportHelper.to_csv(
              use_case.execute(test_start_date, 0, "2021-02-28"),
            )
          end
          let(:fixture_csv) { read_csv_fixture("commercial_rr") }
          let(:parsed_exported_data) { CSV.parse(csv_data, headers: true) }

          it "returns the data exported to a csv object to match the .csv fixture" do
            expect(parsed_exported_data.length).to eq(fixture_csv.length)
            expect(parsed_exported_data.headers - fixture_csv.headers).to eq([])
          end

          5.times do |i|
            it "returns the data exported for row #{i} object to match same row in the .csv fixture " do
              expect(parsed_exported_data[i].to_a - fixture_csv[i].to_a).to eq(
                [],
              )
            end
          end
        end
      end

      context "Then we invoke the Open Data Communities export Rake directly" do
        context "And we set the correct environment variables to send the certificate data to S3" do
          before do
            EnvironmentStub
              .all
              .with("DATE_FROM", test_start_date)
              .with("ASSESSMENT_TYPE", "CEPC")
              .except("DATE_TO")
            HttpStub.s3_put_csv(file_name("CEPC"))
          end

          let(:fixture_csv) { read_csv_fixture("commercial") }

          it "check the http stub matches the request disabled in web mock using the filename, body and headers" do
            get_task("open_data_export").invoke

            expect(WebMock).to have_requested(
              :put,
              "#{HttpStub::S3_BUCKET_URI}open_data_export_cepc_#{DateTime.now.strftime('%F')}_1.csv",
            ).with(
              body: regex_body(fixture_csv.headers),
              headers: {
                "Host" => "s3.eu-west-2.amazonaws.com",
              },
            )
          end
        end

        context "Set the correct environment variables invoke the task to send the recommendation report data to S3" do
          before do
            EnvironmentStub
              .all
              .with("DATE_FROM", test_start_date)
              .with("ASSESSMENT_TYPE", "CEPC-RR")
              .except("DATE_TO")
            HttpStub.s3_put_csv(file_name("CEPC-RR"))
          end
          let(:fixture_csv) { read_csv_fixture("commercial_rr") }

          it "check the http stub matches the request disabled in web mock using the filename, body and headers" do
            get_task("open_data_export").invoke

            expect(WebMock).to have_requested(
              :put,
              "#{HttpStub::S3_BUCKET_URI}open_data_export_cepc-rr_#{DateTime.now.strftime('%F')}_1.csv",
            ).with(
              body: regex_body(fixture_csv.headers),
              headers: {
                "Host" => "s3.eu-west-2.amazonaws.com",
              },
            )
          end
        end
      end
    end

    context "And it is a DEC assessment" do
      before(:all) do
        dec_xml =
          get_assessment_xml(
            "CEPC-8.0.0",
            "0000-0000-0000-0000-0003",
            test_start_date,
            "dec",
          )
        lodge_assessment(
          assessment_body: dec_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "CEPC-8.0.0",
        )

        dec_xml =
          get_assessment_xml(
            "CEPC-8.0.0",
            "0000-0000-0000-0000-0012",
            test_to_date,
            "dec",
          )
        lodge_assessment(
          assessment_body: dec_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "CEPC-8.0.0",
        )

        dec_rr_xml =
          get_recommendations_xml(
            "CEPC-8.0.0",
            test_start_date,
            "dec+rr",
            "1111",
          )
        lodge_assessment(
          assessment_body: dec_rr_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "CEPC-8.0.0",
        )

        dec_rr_xml =
          get_recommendations_xml("CEPC-8.0.0", test_to_date, "dec+rr", "1112")
        lodge_assessment(
          assessment_body: dec_rr_xml.to_xml,
          accepted_responses: [201],
          auth_data: {
            scheme_ids: [@scheme_id],
          },
          override: true,
          schema_name: "CEPC-8.0.0",
        )
      end

      context "Then it calls the use case to extract the data" do
        context "for the DEC certificates" do
          let(:dec_use_case) { UseCase::ExportOpenDataDec.new }
          let(:csv_data) do
            Helper::ExportHelper.to_csv(
              dec_use_case.execute(test_start_date, 0, "2021-02-28"),
            )
          end

          let(:parsed_exported_data) { CSV.parse(csv_data, headers: true) }

          let(:fixture_csv) { read_csv_fixture("dec") }

          it "returns the data exported to a csv object to match the .csv fixture " do
            expect(parsed_exported_data.headers - fixture_csv.headers).to eq([])
            expect(parsed_exported_data.length).to eq(fixture_csv.length)
          end

          let(:first_dec_asssement) do
            parsed_exported_data.find do |item|
              item["ASSESSMENT_ID"] ==
                "36ae715ec66a32ed9ffcd7fe9a2c44d91dec1d72ee26263c17f354167be8dd4b"
            end
          end

          let(:second_dec_asssement) do
            parsed_exported_data.find do |item|
              item["ASSESSMENT_ID"] ==
                "427ad45e88b1183572234b464ba07b37348243d120db1c478da42eda435e48e4"
            end
          end

          it "returns the data exported for row 1 object to match same row in the .csv fixture " do
            expect(
              redact_lodgement_datetime(first_dec_asssement) -
                redact_lodgement_datetime(fixture_csv[0]),
            ).to eq([])
          end

          it "returns the data exported for row 2 to match same row in the .csv fixture " do
            expect(
              redact_lodgement_datetime(second_dec_asssement) -
                redact_lodgement_datetime(fixture_csv[1]),
            ).to eq([])
          end
        end

        context "for the DEC recommendation reports" do
          let(:use_case) { UseCase::ExportOpenDataDecrr.new }
          let(:csv_data) do
            Helper::ExportHelper.to_csv(
              use_case
                .execute(test_start_date, 0, "2021-02-28")
                .sort_by! { |key| key[:recommendation_item] },
            )
          end

          let(:fixture_csv) { read_csv_fixture("dec_rr") }
          let(:parsed_exported_data) { CSV.parse(csv_data, headers: true) }

          it "returns the data exported to a csv object to match the .csv fixture " do
            expect(parsed_exported_data.length).to eq(fixture_csv.length)
            expect(parsed_exported_data.headers - fixture_csv.headers).to eq([])
          end

          5.times do |i|
            it "returns the data exported for row #{i} object to match same row in the .csv fixture " do
              expect(parsed_exported_data[i].to_a - fixture_csv[i].to_a).to eq(
                [],
              )
            end
          end
        end
      end

      context "Then we invoke the Open Data Communities export Rake directly" do
        context "And we set the correct environment variables to send the certificate data to S3" do
          before do
            EnvironmentStub
              .all
              .with("DATE_FROM", test_start_date)
              .with("ASSESSMENT_TYPE", "DEC")
              .except("DATE_TO")
            HttpStub.s3_put_csv(file_name("DEC"))
          end

          let(:regex_body_pattern) do
            fixture_headers = %w[
              YR1_ELECTRICITY_CO2,YR2_ELECTRICITY_CO2,YR1_HEATING_CO2,YR2_HEATING_CO2,YR1_RENEWABLES_CO2,YR2_RENEWABLES_CO2,AIRCON_PRESENT,AIRCON_KW_RATING,ESTIMATED_AIRCON_KW_RATING
            ]
            regex_body(fixture_headers)
          end

          it "check the http stub matches the request disabled in web mock using the filename, body and headers" do
            get_task("open_data_export").invoke
            expect(WebMock).to have_requested(
              :put,
              "#{HttpStub::S3_BUCKET_URI}open_data_export_dec_#{DateTime.now.strftime('%F')}_1.csv",
            ).with(
              body: regex_body_pattern,
              headers: {
                "Host" => "s3.eu-west-2.amazonaws.com",
              },
            )
          end
        end

        context "And we set correct environment variables to send the recommendation report data to S3" do
          before do
            EnvironmentStub
              .all
              .with("DATE_FROM", test_start_date)
              .with("ASSESSMENT_TYPE", "DEC-RR")
              .except("DATE_TO")
            HttpStub.s3_put_csv(file_name("DEC-RR"))
          end

          let(:fixture_csv) { read_csv_fixture("dec_rr") }

          it "check the http stub matches the request disabled in web mock using the filename, body and headers" do
            get_task("open_data_export").invoke
            expect(WebMock).to have_requested(
              :put,
              "#{HttpStub::S3_BUCKET_URI}open_data_export_dec-rr_#{DateTime.now.strftime('%F')}_1.csv",
            ).with(
              body: regex_body(fixture_csv.headers),
              headers: {
                "Host" => "s3.eu-west-2.amazonaws.com",
              },
            )
          end
        end
      end
    end
  end

  context "When invoking the Open Data Communities export rake directly" do
    context "And we provide environment variables" do
      before do
        EnvironmentStub
          .all
          .except("BUCKET_NAME")
          .except("DATE_FROM")
          .except("ASSESSMENT_TYPE")
      end

      it "fails if no bucket or instance name is defined in environment variables" do
        expect { get_task("open_data_export").invoke }.to output(
          /A required argument is missing/,
        ).to_stderr
      end
    end

    context "And we set the incorrect assessment type environment variable" do
      before do
        EnvironmentStub
          .all
          .with("DATE_FROM", DateTime.now.strftime("%F"))
          .with("ASSESSMENT_TYPE", "TEST")
      end

      it "returns the type is not valid error message" do
        expect { get_task("open_data_export").invoke }.to output(
          /Assessment type is not valid:/,
        ).to_stderr
      end
    end

    context "And we set the correct environment variables and a date of now" do
      before do
        EnvironmentStub
          .all
          .with("DATE_FROM", DateTime.now.strftime("%F"))
          .with("ASSESSMENT_TYPE", "SAP-RDSAP")
      end

      it "returns a no data to export error" do
        expect { get_task("open_data_export").invoke }.to output(
          /No data provided for export/,
        ).to_stderr
      end
    end

    context "And we set the correct environment variables and a date range with no assessments" do
      before do
        EnvironmentStub
          .all
          .with("DATE_FROM", "2018-12-01")
          .with("ASSESSMENT_TYPE", "SAP-RDSAP")
          .with("DATE_TO", "2019-12-07")
      end

      it "returns a no data to export error" do
        expect { get_task("open_data_export").invoke }.to output(
          /No data provided for export/,
        ).to_stderr
      end
    end
  end
end
