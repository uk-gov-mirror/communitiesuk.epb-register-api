module UseCase
  class MigrateDomesticEnergyAssessment
    def initialize(domestic_energy_assessments_gateway)
      @domestic_energy_assessments_gateway = domestic_energy_assessments_gateway
    end

    def execute(assessment_id, assessment_body)
      @domestic_energy_assessments_gateway.insert_or_update(
        assessment_id,
        assessment_body
      )

      assessment_body[:assessment_id] = assessment_id
      assessment_body
    end

    def execute_with_object(domestic_energy_assessment)
      @domestic_energy_assessments_gateway.insert_or_update_with_object(domestic_energy_assessment)
      domestic_energy_assessment
    end
  end
end
