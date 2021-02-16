module ViewModel
  module SapSchema120
    class Rdsap < ViewModel::SapSchema120::CommonSchema
      def property_age_band
        xpath(%w[Construction-Age-Band])
      end
    end
  end
end
