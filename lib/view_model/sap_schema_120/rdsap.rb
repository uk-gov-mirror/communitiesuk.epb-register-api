module ViewModel
  module SapSchema120
    class Rdsap < ViewModel::SapSchema120::CommonSchema
      def property_age_band
        xpath(%w[Construction-Age-Band])
      end

      def mechanical_ventilation
        xpath(%w[Mechanical-Ventilation])
      end

      def glazed_area
        xpath(%w[Glazed-Area])
      end
    end
  end
end
