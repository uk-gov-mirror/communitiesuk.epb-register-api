module ViewModel
  module Dec
    class DecWrapper
      TYPE_OF_ASSESSMENT = "DEC".freeze

      def initialize(xml, schema_type)
        case schema_type
        when "CEPC-8.0.0"
          @view_model = ViewModel::Dec::Dec800.new xml
        else
          raise ArgumentError, "Unsupported schema type"
        end
      end

      def type
        :DEC
      end

      def to_hash
        {
          assessment_id: @view_model.assessment_id,
          date_of_expiry: @view_model.date_of_expiry,
          energy_efficiency_rating: @view_model.energy_efficiency_rating,
          energy_efficiency_band:
            get_energy_rating_band(@view_model.energy_efficiency_rating.to_i),
          address: {
            address_id: @view_model.address_id,
            address_line1: @view_model.address_line1,
            address_line2: @view_model.address_line2,
            address_line3: @view_model.address_line3,
            address_line4: @view_model.address_line4,
            town: @view_model.town,
            postcode: @view_model.postcode,
          },
          type_of_assessment: "DEC",
          report_type: @view_model.report_type,
        }
      end

      def get_energy_rating_band(number)
        case number
        when 0..25
          "a"
        when 26..50
          "b"
        when 51..75
          "c"
        when 76..100
          "d"
        when 101..125
          "e"
        when 126..150
          "f"
        else
          "g"
        end
      end
    end
  end
end