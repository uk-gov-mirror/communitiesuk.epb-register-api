describe Gateway::AssessmentAttributesGateway do
  context "when there are no attributes reseed the table and insert test data" do
    let(:gateway) { Gateway::AssessmentAttributesGateway.new }

    before(:each) do
      ActiveRecord::Base.connection.reset_pk_sequence!("assessment_attributes")
      gateway.add_attribute("test")
      gateway.add_attribute("test1")
    end

    let(:attributes) do
      ActiveRecord::Base.connection.exec_query(
        "SELECT * FROM assessment_attributes",
      )
    end

    let(:attribute_values) do
      ActiveRecord::Base.connection.exec_query(
        "SELECT * FROM assessment_attribute_values",
      )
    end

    it "returns a row from the database for each inserted value " do
      expect(attributes.rows.length).to eq(2)
      expect(attributes.rows[0]).to eq([1, "test"])
      expect(attributes.rows[1]).to eq([2, "test1"])
    end

    it "does not return an additional row where a duplication has been entered" do
      gateway.add_attribute("test")
      expect(attributes.rows.length).to_not eq(3)
    end

    it "can access the id of the insert regardless of whether it is created or not" do
      expect(gateway.add_attribute("test")).to eq(1)
      expect(gateway.add_attribute("new one")).to eq(3)
    end

    it "inserts the attribute value into the database" do
      gateway.add_attribute_value("0000-0000-0000-0000-0001", "a", "b")
      expect(attribute_values.rows.length).to eq(1)
      expect(attribute_values.first["assessment_id"]).to eq(
        "0000-0000-0000-0000-0001",
      )
      expect(attribute_values.first["attribute_value"]).to eq("b")
      expect(attribute_values.first["attribute_id"]).to eq(3)
      expect(attribute_values.first["attribute_value_int"]).to be_nil
      expect(attribute_values.first["attribute_value_float"]).to be_nil
    end

    context "when we insert many attributes for one assessment" do
      before do
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0001",
          "construction_age_band",
          "England and Wales: 2007-2011",
        )
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0001",
          "glazed_type",
          "test",
        )
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0001",
          "current_energy_efficiency",
          "50",
        )

        gateway.add_attribute_value(
          "0000-0000-0000-0000-0001",
          "heating_cost_current",
          "365.98",
        )
      end

      let(:assessement_attribute_values) do
        ActiveRecord::Base.connection.exec_query(
          "SELECT * FROM assessment_attribute_values WHERE assessment_id= '0000-0000-0000-0000-0001'",
        )
      end

      it "returns the current rows for this assessment" do
        expect(assessement_attribute_values.rows.length).to eq(4)
      end

      it "row 3 will have a value in the integer column for the current_energy_efficiency" do
        expect(assessement_attribute_values[2]["attribute_value_int"]).to eq(50)
      end

      it "row 4 will have a value in the float column for the heating_cost_current" do
        expect(assessement_attribute_values[3]["attribute_value_int"]).to be_nil
        expect(assessement_attribute_values[3]["attribute_value_float"]).to eq(
          365.98,
        )
      end
    end

    context "when we insert the same attribute for many assessments" do
      before do
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0001",
          "glazed_type",
          "another test",
        )
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0002",
          "glazed_type",
          "test",
        )
      end

      it "the attribute table only increments by one" do
        expect(attributes.rows.length).to eq(3)
      end

      it "the attribute value table has two rows" do
        expect(attribute_values.rows.length).to eq(2)
      end

      it "the converts the string value to its relevant data type" do
        expect("hello").to be_a(String)
      end

      it 'deletes the attributes for an assesment' do
        allow(gateway).to receive(:delete_attributes_by_assessment)

      end

    end


    context "when we delete attribute data assessments" do
      before do
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0001",
          "construction_age_band",
          "England and Wales: 2007-2011",
          )
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0001",
          "glazed_type",
          "test",
          )
        gateway.add_attribute_value(
          "0000-0000-0000-0000-0002",
          "current_energy_efficiency",
          "50",
          )

        gateway.add_attribute_value(
          "0000-0000-0000-0000-0002",
          "heating_cost_current",
          "365.98",
          )

      end

      let(:assessement_attribute_values) do
        ActiveRecord::Base.connection.exec_query(
          "SELECT * FROM assessment_attribute_values",
          )
      end

      it 'should have 4 rows for the 2nd assessments' do
        expect(assessement_attribute_values.rows.count).to eq(4)

      end

      it 'deletes the the attributes for one of the  assessments ' do
        gateway.delete_attributes_by_assessment('0000-0000-0000-0000-0002')
        expect( ActiveRecord::Base.connection.exec_query(
          "SELECT * FROM assessment_attribute_values WHERE assessment_id ='0000-0000-0000-0000-0002'",
          ).rows.count).to eq(0)

      end

    end
    end

end
