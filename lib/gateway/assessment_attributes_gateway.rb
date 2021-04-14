module Gateway
  class AssessmentAttributesGateway
    def add_attribute(attribute_name)
      attribute_data = fetch_attribute_id(attribute_name)
      if attribute_data.nil?
        insert_attribute(attribute_name)
      else
        attribute_data["attribute_id"]
      end
    end

    def add_attribute_value(asessement_id, attribute_name, attribute_value)
      ActiveRecord::Base.transaction do
        attribute_id = add_attribute(attribute_name)
        insert_attribute_value(asessement_id, attribute_id, attribute_value)
      end
    end

    def delete_attributes_by_assessment(assessment_id)
      sql = <<-SQL
              DELETE FROM assessment_attribute_values
              WHERE assessment_id = $1
      SQL

      bindings = [
        ActiveRecord::Relation::QueryAttribute.new(
          "assessment_id",
          assessment_id,
          ActiveRecord::Type::String.new,
        ),
      ]

      ActiveRecord::Base.connection.exec_query(sql, "SQL", bindings)
    end

    def fetch_assessment_attributes(column_array)
      sql =
        "SELECT *
              FROM crosstab('SELECT  assessment_id, attribute_name, attribute_value
              FROM assessment_attribute_values
              JOIN assessment_attributes ON assessment_attribute_values.attribute_id = assessment_attributes.attribute_id
              ORDER BY 1,2')
            AS columns(#{set_columns(column_array)})"

      ActiveRecord::Base.connection.exec_query(sql, "SQL")
    end

  private

    def set_columns(column_array)
      columns = column_array.map { |name| name + " varchar" }
      columns.join(", ")
    end

    def fetch_attribute_id(attribute_name)
      sql = <<-SQL
             SELECT attribute_id
              FROM assessment_attributes WHERE attribute_name = $1
              LIMIT 1
      SQL
      ActiveRecord::Base
        .connection
        .exec_query(sql, "SQL", attribute_name_binding(attribute_name))
        .first
    end

    def attribute_name_binding(attribute_name)
      bindings = [
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_name",
          attribute_name,
          ActiveRecord::Type::String.new,
        ),
      ]
    end

    def insert_attribute(attribute_name)
      insert_sql = <<-SQL
              INSERT INTO assessment_attributes(attribute_name)
              VALUES($1)
      SQL

      ActiveRecord::Base.connection.insert(
        insert_sql,
        nil,
        nil,
        nil,
        nil,
        attribute_name_binding(attribute_name),
      )
    end

    def insert_attribute_value(assessment_id, attribute_id, attribute_value)
      sql = <<-SQL
              INSERT INTO assessment_attribute_values(assessment_id, attribute_id, attribute_value, attribute_value_int, attribute_value_float)
              VALUES($1, $2, $3, $4, $5)
      SQL

      attribute_value_int =
        begin
          Integer(attribute_value)
        rescue StandardError
          nil
        end
      attribute_value_float =
        begin
          Float(attribute_value)
        rescue StandardError
          nil
        end

      bindings = [
        ActiveRecord::Relation::QueryAttribute.new(
          "assessment_id",
          assessment_id,
          ActiveRecord::Type::String.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_id",
          attribute_id,
          ActiveRecord::Type::BigInteger.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_value",
          attribute_value,
          ActiveRecord::Type::String.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_int",
          attribute_value_int,
          ActiveRecord::Type::BigInteger.new,
        ),
        ActiveRecord::Relation::QueryAttribute.new(
          "attribute_float",
          attribute_value_float,
          ActiveRecord::Type::Decimal.new,
        ),
      ]

      ActiveRecord::Base.connection.insert(sql, nil, nil, nil, nil, bindings)
    end
  end
end
