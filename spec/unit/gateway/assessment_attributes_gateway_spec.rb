describe Gateway::AssessmentAttributesGateway do
  context "when there are no attributes reseed the table and insert test data" do
    let(:gateway) { Gateway::AssessmentAttributesGateway.new }

    before(:each) do
      ActiveRecord::Base.connection.reset_pk_sequence!("assessment_attributes")
      gateway.add_attribute("test")
      gateway.add_attribute("test1")
    end

    let(:attribute) do
      ActiveRecord::Base.connection.exec_query(
        "SELECT * FROM assessment_attributes",
      )
    end

    it "returns a row from the database for each inserted value " do
      expect(attribute.rows.length).to eq(2)
      expect(attribute.rows[0]).to eq([1, "test"])
      expect(attribute.rows[1]).to eq([2, "test1"])
    end

    it "does not return an additional row where a duplication has been entered" do
      gateway.add_attribute("test")
      expect(attribute.rows.length).to_not eq(3)
    end

    it "can access the id of the insert regardless of whether it is created or not" do
      expect(gateway.add_attribute("test")).to eq(1)
      expect(gateway.add_attribute("new one")).to eq(3)
    end

    it 'inserts the attribute value into the database' do
      allow(gateway).to receive(:add_attribute_value)
    end


  end
end
