module ViewModel
  module SapSchemaNi1800
    class CommonSchema
      def initialize(xml)
        @xml_doc = Nokogiri.XML xml
      end

      def xpath(queries)
        node = @xml_doc
        queries.each { |query| node = node.at query }
        node ? node.content : nil
      end
    end
  end
end
