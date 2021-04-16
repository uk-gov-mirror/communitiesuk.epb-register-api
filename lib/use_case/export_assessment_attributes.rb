module UseCase
  class ExportAssessmentAttributes
    def initialize
      @assessment_attribute_gateway = Gateway::AssessmentAttributesGateway.new
    end

    def execute(attribute_columns, hash_rrn = false)
      attribute_columns.reject! { |i| i == "assessment_id" }

      assessments =
        @assessment_attribute_gateway.fetch_assessment_attributes attribute_columns

      if hash_rrn
        assessments.each do |assessment|
          assessment["assessment_id"] =
            Helper::RrnHelper.hash_rrn(assessment["assessment_id"])
        end
      end
      assessments
    end
  end
end
