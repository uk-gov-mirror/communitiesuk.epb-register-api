module ViewModel
  module Common
    class SchemaCepc800
      #This class should contain fields only that are common
      #to ALL types of CEPC-8.0.0 documents: CEPC, RR, DEC, AC, etc

      def initialize(xml)
        @xml_doc = Nokogiri.XML xml
      end

      def xpath(queries)
        node = @xml_doc
        queries.each { |query| node = node.at query }
        node ? node.content : nil
      end

      def assessment_id
        xpath(%w[RRN])
      end

      def date_of_expiry
        xpath(%w[Valid-Until])
      end

      def report_type
        xpath(%w[Report-Type])
      end

      def address_line1
        xpath(%w[Property-Address Address-Line-1])
      end

      def address_line2
        xpath(%w[Property-Address Address-Line-2])
      end

      def address_line3
        xpath(%w[Property-Address Address-Line-3])
      end

      def address_line4
        xpath(%w[Property-Address Address-Line-4])
      end

      def town
        xpath(%w[Property-Address Post-Town])
      end

      def postcode
        xpath(%w[Property-Address Postcode])
      end
    end
  end
end
