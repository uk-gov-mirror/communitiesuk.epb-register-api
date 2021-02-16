module UseCase
  class FindAssessmentsByStreetNameAndTown
    class ParameterMissing < Boundary::ValidationError; end

    def initialize
      @assessment_gateway = Gateway::AssessmentsSearchGateway.new
    end

    def execute(street_name, town, assessment_type)
      if street_name.blank? || town.blank?
        raise ParameterMissing, "Required query params missing"
      end

      result =
        @assessment_gateway.search_by_street_name_and_town(
          street_name,
          town,
          assessment_type,
        )

      Helper::NaturalSort.sort!(result)

      { data: result.map(&:to_hash), search_query: [street_name, town] }
    end
  end
end
