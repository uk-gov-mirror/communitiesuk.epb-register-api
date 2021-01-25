module UseCase
  module AssessmentSummary
    class Fetch
      class NotFoundException < StandardError; end
      class AssessmentGone < StandardError; end

      def lodged_values_from_xml(xml, schema_type, assessment_id)
        view_model =
          ViewModel::Factory.new.create(xml, schema_type, assessment_id)
        unless view_model
          raise ArgumentError,
                "Assessment summary unsupported for this assessment type"
        end
        view_model
      end

      def execute(assessment_id)
        assessment_id = Helper::RrnHelper.normalise_rrn_format(assessment_id)
        assessment =
          Gateway::AssessmentsSearchGateway
            .new
            .search_by_assessment_id(assessment_id, false)
            .first

        if assessment
          if %w[CANCELLED NOT_FOR_ISSUE].include? assessment.to_hash[:status]
            raise AssessmentGone
          end
        else
          raise NotFoundException
        end

        lodged_xml_document =
          Gateway::AssessmentsXmlGateway.new.fetch assessment_id
        raise NotFoundException unless lodged_xml_document

        lodged_values =
          lodged_values_from_xml(
            lodged_xml_document[:xml],
            lodged_xml_document[:schema_type],
            assessment_id,
          )

        lodged_data = lodged_values.to_hash
        assessment_data = assessment.to_hash

        lodged_data[:address_id] = assessment_data[:address_id]
        lodged_data[:opt_out] = assessment_data[:opt_out]

        summary =
          case lodged_values.type
          when :AC_CERT
            AcCertSupplement.new.add_data!(lodged_data)
          when :AC_REPORT
            AcReportSupplement.new.add_data!(lodged_data)
          when :CEPC
            CepcSupplement.new.add_data!(lodged_data)
          when :CEPC_RR
            CepcRrSupplement.new.add_data!(lodged_data)
          when :DEC
            DecSupplement.new.add_data!(lodged_data)
          when :DEC_RR
            DecRrSupplement.new.add_data!(lodged_data)
          when :SAP
            SapSupplement.new.add_data!(lodged_data)
          when :RdSAP
            RdSapSupplement.new.add_data!(lodged_data)
          else
            lodged_data
          end

        summary
      end
    end
  end
end
