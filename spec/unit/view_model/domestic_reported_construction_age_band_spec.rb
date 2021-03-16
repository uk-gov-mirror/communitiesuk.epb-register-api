describe "ViewModel::Domestic::ConstructionAgeBand" do

  context "when there is a construction age band value or construction year for the Main Dwelling" do
    def self.retrieve_construction_age_band(schema, type, construction_option)
      it "returns the value for construction age band or construction year" do
        document = Nokogiri.XML Samples.xml(schema, type)
        wrapper = ViewModel::Factory.new.create(document.to_s, schema.to_s)

        age_band = wrapper.get_view_model.main_dwelling_construction_age_band_or_year

        expect(age_band).to eq(construction_option)
      end
    end

    retrieve_construction_age_band('SAP-Schema-18.0.0', 'epc', '1750')
    retrieve_construction_age_band('SAP-Schema-17.1', 'epc', '1750')
    retrieve_construction_age_band('SAP-Schema-17.0', 'epc', '1750')
    retrieve_construction_age_band('SAP-Schema-16.3', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-16.3', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-16.2', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-16.2', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-16.1', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-16.1', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-16.0', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-16.0', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-15.0', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-15.0', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-14.2', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-14.2', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-14.1', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-14.1', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-14.0', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-14.0', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-13.0', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-13.0', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-12.0', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-12.0', 'rdsap', 'A')
    retrieve_construction_age_band('SAP-Schema-11.2', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-11.2', 'rdsap', 'C')
    retrieve_construction_age_band('SAP-Schema-11.0', 'sap', '1750')
    retrieve_construction_age_band('SAP-Schema-11.0', 'rdsap', 'C')
    retrieve_construction_age_band('SAP-Schema-10.2', 'rdsap', 'C')

    retrieve_construction_age_band('RdSAP-Schema-20.0.0', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-19.0', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-18.0', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-17.1', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-17.0', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-NI-20.0.0', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-NI-19.0', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-NI-18.0', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-NI-17.4', 'epc', 'K')
    retrieve_construction_age_band('RdSAP-Schema-NI-17.3', 'epc', 'K')
  end
end

