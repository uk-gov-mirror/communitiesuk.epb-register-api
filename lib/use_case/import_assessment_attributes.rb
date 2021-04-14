module UseCase
  class ImportAssessmentAttributes
    def initialize
      @assessment_gateway = Gateway::AssessmentsXmlGateway.new
      @assessment_attribute_gateway = Gateway::AssessmentAttributesGateway.new
    end

    def execute(assessment_id)
      xml_data = @assessment_gateway.fetch(assessment_id)

      # TODO: Query the database to extract all asessement that have not entries in the assessment_attribute_value table

      view_model =
        ViewModel::Factory.new.create(
          xml_data[:xml],
          xml_data[:schema_type],
          assessment_id,
        )
      view_model_hash = view_model.to_report
      view_model.to_report.each do |key, value|
        @assessment_attribute_gateway.add_attribute_value(
          assessment_id,
          key,
          value,
        )
      end

      view_model_hash
    end
  end
end
