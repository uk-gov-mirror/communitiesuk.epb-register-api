module UseCase
  class FindAssessmentsByPostcode
    class PostcodeNotValid < Boundary::ValidationError; end
    class ParameterMissing < Boundary::ValidationError; end
    class AssessmentTypeNotValid < Boundary::ValidationError; end

    def initialize
      @assessments_gateway = Gateway::AssessmentsSearchGateway.new
    end

    def execute(postcode, assessment_types = [])
      postcode&.strip!
      postcode&.upcase!

      raise ParameterMissing, "Required query params missing" if postcode.blank?

      postcode = Helper::ValidatePostcodeHelper.new.validate_postcode(postcode)

      unless Regexp
               .new(Helper::RegexHelper::POSTCODE, Regexp::IGNORECASE)
               .match(postcode)
        raise PostcodeNotValid, "Required query params missing"
      end

      result =
        @assessments_gateway.search_by_postcode(postcode, assessment_types)

      Helper::NaturalSort.sort!(result)

      { data: result.map(&:to_hash), searchQuery: postcode }
    rescue Gateway::AssessmentsSearchGateway::InvalidAssessmentType
      raise AssessmentTypeNotValid, "The requested assessment type is not valid"
    end
  end
end
