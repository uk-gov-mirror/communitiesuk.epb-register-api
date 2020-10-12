# frozen_string_literal: true

module Controller
  class ReportingController < Controller::BaseController
    get "/api/reports/assessments/region-and-type", jwt_auth: %w[reporting] do
      raw_data =
        body UseCase::GetAssessmentCountByRegionAndType.new.execute(
          Date.parse(params["start_date"]),
          Date.parse(params["end_date"]),
        )

      body CSV.generate(
        write_headers: true, headers: raw_data.first.keys,
      ) { |csv| raw_data.each { |row| csv << row } }
    end
  end
end