module UseCase
  class ExportAssessmentAttributes
    def initialize
      @assessment_attribute_gateway = Gateway::AssessmentAttributesGateway.new
    end

    def execute(column_array)
      @assessment_attribute_gateway.fetch_assessment_attributes column_array
    end
  end
end
