module UseCase
  class ImportAssessmentAttributes
    def initialize
      @assessment_gateway = Gateway::AssessmentsXmlGateway.new
      @assessment_attribute_gateway = Gateway::AssessmentAttributesGateway.new
    end

    def execute
      assessments = @assessment_attribute_gateway.fetch_assessments_to_add

      assessments.each do |assessment|
        xml_data = @assessment_gateway.fetch(assessment["assessment_id"])

        view_model =
          ViewModel::Factory.new.create(
            xml_data[:xml],
            xml_data[:schema_type],
            assessment["assessment_id"],
          )
        view_model_hash = view_model.to_report

        view_model_hash.each do |key, value|
          @assessment_attribute_gateway.add_attribute_value(
            assessment["assessment_id"],
            key,
            value,
          )
        end
        @assessment_attribute_gateway.add_attribute_value(
          assessment["assessment_id"],
          "hashed_assessment_id",
          Helper::RrnHelper.hash_rrn(assessment["assessment_id"]),
        )
      end
    end
  end
end
